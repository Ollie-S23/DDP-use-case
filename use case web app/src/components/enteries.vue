<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

// ── Route params ───────────────────────────────────────────────────────────────
const roundId = Number(route.query.round_id)
const archer = (() => {
  try {
    return JSON.parse(route.query.archers)[0]
  } catch {
    return null
  }
})()

// ── Data ───────────────────────────────────────────────────────────────────────
const ranges = ref([])
const loadError = ref('')
const activeRangeIdx = ref(0)

async function fetchRanges() {
  try {
    const res = await fetch(`/apis.php?query=ranges_for_round&round_id=${roundId}`)
    if (!res.ok) {
      loadError.value = `Server error ${res.status}`
      return
    }
    const data = await res.json()
    ranges.value = data
  } catch (err) {
    loadError.value = `Could not reach server (${err.message})`
  }
}

onMounted(fetchRanges)

// ── Score state ────────────────────────────────────────────────────────────────
// scores[rangeIdx][endIdx][arrowIdx] = score string or null
const ARROW_VALUES = ['X', '10', '9', '8', '7', '6', '5', '4', '3', '2', '1', 'M']
const ARROWS_PER_END = 6

const scores = ref([])

function ensureScores() {
  scores.value = ranges.value.map((rng) =>
    Array.from({ length: Number(rng.num_ends) }, () => Array(ARROWS_PER_END).fill(null)),
  )
}

watch(ranges, ensureScores, { immediate: true })

// ── Active range ───────────────────────────────────────────────────────────────
const activeRange = computed(() => ranges.value[activeRangeIdx.value] ?? null)
const activeRangeScores = computed(() => scores.value[activeRangeIdx.value] ?? [])

// ── Scoring helpers ────────────────────────────────────────────────────────────
function numericVal(s) {
  if (s === null) return 0
  if (s === 'X') return 10
  if (s === 'M') return 0
  return Number(s)
}

function endTotal(endArrows) {
  return endArrows.reduce((sum, s) => sum + numericVal(s), 0)
}

function runningTotal(endIdx) {
  let total = 0
  for (let e = 0; e <= endIdx; e++) {
    total += endTotal(activeRangeScores.value[e] ?? [])
  }
  return total
}

const grandTotal = computed(() =>
  scores.value.reduce(
    (sum, rangeEnds) => sum + rangeEnds.reduce((s, end) => s + endTotal(end), 0),
    0,
  ),
)

// ── All ends complete ──────────────────────────────────────────────────────────
const allComplete = computed(() =>
  scores.value.length > 0 &&
  scores.value.every((rangeEnds) => rangeEnds.every((end) => end.every((s) => s !== null))),
)

// ── Summary overlay ────────────────────────────────────────────────────────────
const showSummary = ref(false)
const submitting = ref(false)
const submitError = ref('')
const submitDone = ref(false)

const isComp = computed(
  () => !!(route.query.comp_id && route.query.comp_id !== 'null'),
)

function rangeTotal(rangeIdx) {
  return (scores.value[rangeIdx] ?? []).reduce((s, end) => s + endTotal(end), 0)
}

async function acceptSubmit() {
  submitting.value = true
  submitError.value = ''
  const payload = {
    archer_id:    archer.archer_id,
    round_def_id: roundId,
    division_id:  archer.division_id,
    age_class_id: archer.age_class_id,
    is_competition: isComp.value,
    comp_id:      isComp.value ? Number(route.query.comp_id) : null,
    ranges: ranges.value.map((rng, idx) => ({
      distance:       rng.distance,
      target_size_cm: rng.target_size_cm,
      ends:           scores.value[idx],
    })),
  }
  try {
    const res = await fetch('/apis.php?query=submit_session', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })
    const data = await res.json()
    if (!res.ok || data.error) {
      submitError.value = data.error ?? `Server error ${res.status}`
    } else {
      submitDone.value = true
    }
  } catch (err) {
    submitError.value = `Could not reach server (${err.message})`
  } finally {
    submitting.value = false
  }
}

// ── Arrow picker ───────────────────────────────────────────────────────────────
const picking = ref(null) // { endIdx, arrowIdx }

function openPicker(endIdx, arrowIdx) {
  picking.value = { endIdx, arrowIdx }
}

function pickScore(val) {
  if (!picking.value) return
  const { endIdx, arrowIdx } = picking.value
  scores.value[activeRangeIdx.value][endIdx][arrowIdx] = val
  picking.value = null
}

function closePicker() {
  picking.value = null
}

// ── Arrow display ──────────────────────────────────────────────────────────────
function arrowLabel(s) {
  return s === null ? '—' : s
}

function arrowClass(s) {
  if (s === null) return 'arrow-empty'
  if (s === 'X' || s === '10') return 'arrow-gold'
  if (s === '9' || s === '8') return 'arrow-red'
  if (s === '7' || s === '6') return 'arrow-blue'
  if (s === '5' || s === '4') return 'arrow-black'
  if (s === '3' || s === '2' || s === '1') return 'arrow-white'
  return 'arrow-miss'
}
</script>

<template>
  <div v-if="loadError" class="alert alert-danger m-3">{{ loadError }}</div>

  <div v-else-if="!ranges.length" class="text-center text-white pt-5">Loading…</div>

  <div v-else class="scoring-shell d-flex flex-column flex-md-row">

    <!-- ── Sidebar: ranges ──────────────────────────────────────────────────── -->
    <nav class="range-sidebar d-flex flex-row flex-md-column gap-2 p-3">
      <div class="sidebar-label d-none d-md-block text-white fw-bold mb-1">Ranges</div>
      <button
        v-for="(rng, idx) in ranges"
        :key="`${rng.distance}-${rng.target_size_cm}`"
        class="range-btn"
        :class="{ active: idx === activeRangeIdx }"
        @click="activeRangeIdx = idx"
      >
        <span class="range-dist">{{ rng.distance }}m</span>
        <span class="range-ends d-none d-md-block">{{ rng.num_ends }} ends</span>
        <span class="range-ends d-none d-md-block">{{ rng.target_size_cm }}cm face</span>
      </button>

      <div class="mt-auto d-none d-md-block">
        <div class="total-chip">
          <div class="total-label">Total</div>
          <div class="total-value">{{ grandTotal }}</div>
        </div>
      </div>
    </nav>

    <!-- ── Right panel: debug bar + ends ─────────────────────────────────────── -->
    <div class="d-flex flex-column flex-grow-1">

      <!-- Debug bar: full width, shown on both mobile and desktop -->
      <div class="debug-bar" v-if="archer">
        {{ archer.name_given }} {{ archer.name_surname }},
        {{ archer.gender === 'M' ? 'Male' : 'Female' }},
        {{ archer.birth_year }} – {{ new Date().getFullYear() - archer.birth_year }}
        — {{ route.query.round_name }}, {{ archer.age_class_name }}, {{ archer.division_name }},
        {{ (route.query.comp_id && route.query.comp_id !== 'null') ? 'Competition' : 'No competition' }}
      </div>

    <!-- ── Main: ends for active range ────────────────────────────────────────── -->
    <main class="ends-area flex-grow-1 p-3">

      <!-- Archer + range heading -->
      <div class="ends-heading mb-3 d-flex align-items-center justify-content-between flex-wrap gap-2">
        <span class="fw-bold text-white" v-if="archer">
          {{ archer.name_given }} {{ archer.name_surname }}
        </span>
        <span class="badge bg-secondary" v-if="activeRange">
          {{ activeRange.distance }}m — {{ activeRange.num_ends }} ends
        </span>
        <span class="total-chip-inline d-md-none">Total: {{ grandTotal }}</span>
      </div>

      <!-- Ends -->
      <div
        v-for="(endArrows, ei) in activeRangeScores"
        :key="ei"
        class="end-card mb-3"
      >
        <div class="end-header">End {{ ei + 1 }}</div>
        <div class="end-body">
          <div class="arrow-row">
            <button
              v-for="(score, ai) in endArrows"
              :key="ai"
              class="arrow-btn"
              :class="arrowClass(score)"
              @click="openPicker(ei, ai)"
            >
              {{ arrowLabel(score) }}
            </button>
          </div>
          <div class="end-totals">
            <span class="end-total-box">{{ endTotal(endArrows) }}</span>
            <span class="running-total">{{ runningTotal(ei) }}</span>
          </div>
        </div>
      </div>

      <!-- Submit button: appears when all ends are filled -->
      <div v-if="allComplete" class="submit-bar p-3">
        <button class="submit-btn w-100" @click="showSummary = true">
          Submit Session
        </button>
      </div>
    </main>
    </div>

    <!-- ── Score picker modal ───────────────────────────────────────────────── -->
    <Teleport to="body">
      <div v-if="picking" class="picker-overlay" @click.self="closePicker">
        <div class="picker-modal">
          <div class="picker-title">Select score</div>
          <div class="picker-grid">
            <button
              v-for="val in ARROW_VALUES"
              :key="val"
              class="picker-btn"
              :class="arrowClass(val)"
              @click="pickScore(val)"
            >
              {{ val }}
            </button>
          </div>
          <button class="picker-cancel" @click="closePicker">Cancel</button>
        </div>
      </div>
    </Teleport>

    <!-- ── Summary / confirm overlay ────────────────────────────────────────── -->
    <Teleport to="body">
      <div v-if="showSummary" class="picker-overlay">
        <div class="summary-modal">

          <!-- Success state -->
          <template v-if="submitDone">
            <div class="summary-title">Submitted!</div>
            <p class="summary-ok-msg">
              {{ isComp
                ? 'Your competition entry is pending review by a verified recorder.'
                : 'Your practice round has been saved to your profile.' }}
            </p>
            <button class="submit-btn w-100 mt-3" @click="showSummary = false; submitDone = false">
              Close
            </button>
          </template>

          <!-- Review state -->
          <template v-else>
            <div class="summary-title">Session Summary</div>

            <!-- Archer + round details -->
            <div class="summary-section" v-if="archer">
              <div class="summary-row">
                <span class="summary-lbl">Archer</span>
                <span>{{ archer.name_given }} {{ archer.name_surname }},
                  {{ archer.gender === 'M' ? 'Male' : 'Female' }},
                  {{ archer.birth_year }} – {{ new Date().getFullYear() - archer.birth_year }}</span>
              </div>
              <div class="summary-row">
                <span class="summary-lbl">Round</span>
                <span>{{ route.query.round_name }}</span>
              </div>
              <div class="summary-row">
                <span class="summary-lbl">Class</span>
                <span>{{ archer.age_class_name }}</span>
              </div>
              <div class="summary-row">
                <span class="summary-lbl">Division</span>
                <span>{{ archer.division_name }}</span>
              </div>
              <div class="summary-row">
                <span class="summary-lbl">Competition</span>
                <span>{{ isComp ? 'Yes' : 'No' }}</span>
              </div>
            </div>

            <!-- Per-range score breakdown -->
            <div class="summary-section">
              <div
                v-for="(rng, ri) in ranges"
                :key="`${rng.distance}-${rng.target_size_cm}`"
                class="summary-range mb-2"
              >
                <div class="summary-range-head">
                  {{ rng.distance }}m — {{ rng.target_size_cm }}cm face
                  <span class="summary-range-total">{{ rangeTotal(ri) }} pts</span>
                </div>
                <div
                  v-for="(endArrows, ei) in scores[ri]"
                  :key="ei"
                  class="summary-end-row"
                >
                  <span class="summary-end-lbl">End {{ ei + 1 }}</span>
                  <span
                    v-for="(s, ai) in endArrows"
                    :key="ai"
                    class="summary-arrow-chip"
                    :class="arrowClass(s)"
                  >{{ s }}</span>
                  <span class="summary-end-score">= {{ endTotal(endArrows) }}</span>
                </div>
              </div>
              <div class="summary-grand-total">Grand Total: {{ grandTotal }}</div>
            </div>

            <!-- Conditional message -->
            <div class="summary-message" :class="isComp ? 'msg-comp' : 'msg-practice'">
              <template v-if="isComp">
                As a competition has been selected, this request will hold pending until a verified recorder reviews the request.
              </template>
              <template v-else>
                A competition was not applied. All information will be added to your profile. You are responsible for the correct details. A verified recorder is not responsible but may in the future alter your details.
              </template>
            </div>

            <div v-if="submitError" class="alert alert-danger mt-2 mb-0" style="font-size:0.8rem">
              {{ submitError }}
            </div>

            <!-- Actions -->
            <div class="summary-actions mt-3">
              <button class="summary-cancel-btn" @click="showSummary = false" :disabled="submitting">
                Cancel
              </button>
              <button class="submit-btn flex-grow-1" @click="acceptSubmit" :disabled="submitting">
                {{ submitting ? 'Submitting…' : 'Accept' }}
              </button>
            </div>
          </template>

        </div>
      </div>
    </Teleport>
  </div>
</template>

<style scoped>
.scoring-shell {
  min-height: 100vh;
  background: #1a2e2b;
}

/* ── Sidebar ──────────────────────────────────────────────────────────────── */
.range-sidebar {
  background: #163028;
  overflow-x: auto;
  flex-shrink: 0;
}

@media (min-width: 768px) {
  .range-sidebar {
    width: 140px;
    min-height: 100vh;
    overflow-x: unset;
    overflow-y: auto;
  }
}

.range-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #2d5a50;
  color: #d0f0ea;
  border: 2px solid transparent;
  border-radius: 8px;
  padding: 10px 14px;
  cursor: pointer;
  white-space: nowrap;
  min-width: 64px;
  transition: background 0.15s, border-color 0.15s;
}

.range-btn.active {
  background: #3aab90;
  border-color: #a0ffe8;
  color: #fff;
  font-weight: 700;
}

.range-btn:hover:not(.active) {
  background: #3d7a6a;
}

.range-dist {
  font-size: 1rem;
  font-weight: 600;
}

.range-ends {
  font-size: 0.7rem;
  opacity: 0.75;
  margin-top: 2px;
}

.debug-bar {
  background: rgba(0, 0, 0, 0.2);
  color: #d0f0ea;
  font-size: 0.78rem;
  padding: 6px 14px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  flex-shrink: 0;
}

.total-chip {
  background: #0f1f1c;
  border-radius: 8px;
  padding: 8px 12px;
  text-align: center;
  color: #a0ffe8;
}

.total-label {
  font-size: 0.7rem;
  opacity: 0.7;
}

.total-value {
  font-size: 1.4rem;
  font-weight: 700;
}

/* ── Ends area ────────────────────────────────────────────────────────────── */
.ends-area {
  max-width: 700px;
}

.ends-heading {
  border-bottom: 1px solid rgba(255,255,255,0.1);
  padding-bottom: 8px;
}

.total-chip-inline {
  background: #0f1f1c;
  color: #a0ffe8;
  font-weight: 700;
  border-radius: 6px;
  padding: 4px 10px;
  font-size: 0.9rem;
}

.end-card {
  background: #253d38;
  border-radius: 10px;
  overflow: hidden;
}

.end-header {
  background: #1e332e;
  color: #a0ffe8;
  font-weight: 600;
  font-size: 0.85rem;
  padding: 6px 12px;
}

.end-body {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 12px;
  flex-wrap: wrap;
}

.arrow-row {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.arrow-btn {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: 2px solid rgba(255,255,255,0.15);
  font-weight: 700;
  font-size: 0.85rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.1s;
}

.arrow-btn:active {
  transform: scale(0.9);
}

.end-totals {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-left: auto;
}

.end-total-box {
  background: #c0392b;
  color: #fff;
  font-weight: 700;
  font-size: 1rem;
  border-radius: 6px;
  padding: 4px 10px;
  min-width: 36px;
  text-align: center;
}

.running-total {
  color: #a0ffe8;
  font-size: 0.85rem;
  opacity: 0.8;
  min-width: 28px;
  text-align: right;
}

/* ── Arrow colors ─────────────────────────────────────────────────────────── */
.arrow-empty  { background: #3a5550; color: #6a9990; }
.arrow-gold   { background: #f0c040; color: #2a1800; border-color: #e0a000; }
.arrow-red    { background: #c0392b; color: #fff;    border-color: #922b21; }
.arrow-blue   { background: #2471a3; color: #fff;    border-color: #1a5276; }
.arrow-black  { background: #2c3e50; color: #fff;    border-color: #1a252f; }
.arrow-white  { background: #ecf0f1; color: #2c3e50; border-color: #bdc3c7; }
.arrow-miss   { background: #1a2e2b; color: #e74c3c; border-color: #e74c3c; }

/* ── Score picker ─────────────────────────────────────────────────────────── */
.picker-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.picker-modal {
  background: #1e332e;
  border-radius: 14px;
  padding: 20px;
  width: 280px;
  box-shadow: 0 8px 32px rgba(0,0,0,0.5);
}

.picker-title {
  color: #a0ffe8;
  font-weight: 600;
  margin-bottom: 14px;
  text-align: center;
}

.picker-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
  margin-bottom: 14px;
}

.picker-btn {
  height: 52px;
  border-radius: 8px;
  border: 2px solid rgba(255,255,255,0.15);
  font-weight: 700;
  font-size: 1rem;
  cursor: pointer;
  transition: transform 0.1s;
}

.picker-btn:active {
  transform: scale(0.9);
}

.picker-cancel {
  width: 100%;
  background: #2d5a50;
  color: #d0f0ea;
  border: none;
  border-radius: 8px;
  padding: 10px;
  font-weight: 600;
  cursor: pointer;
}

.picker-cancel:hover {
  background: #3d7a6a;
}

/* ── Submit bar + button ──────────────────────────────────────────────────── */
.submit-bar {
  border-top: 1px solid rgba(255,255,255,0.08);
}

.submit-btn {
  background: #3aab90;
  color: #fff;
  font-weight: 700;
  font-size: 1rem;
  border: none;
  border-radius: 8px;
  padding: 12px 20px;
  cursor: pointer;
  transition: background 0.15s;
}

.submit-btn:hover:not(:disabled) {
  background: #2d8a72;
}

.submit-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* ── Summary modal ────────────────────────────────────────────────────────── */
.summary-modal {
  background: #1e332e;
  border-radius: 14px;
  padding: 24px;
  width: min(680px, 95vw);
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 8px 32px rgba(0,0,0,0.6);
}

.summary-title {
  color: #a0ffe8;
  font-size: 1.2rem;
  font-weight: 700;
  margin-bottom: 16px;
  text-align: center;
}

.summary-section {
  background: rgba(0,0,0,0.15);
  border-radius: 8px;
  padding: 12px 14px;
  margin-bottom: 14px;
}

.summary-row {
  display: flex;
  gap: 10px;
  color: #d0f0ea;
  font-size: 0.85rem;
  padding: 3px 0;
}

.summary-lbl {
  color: #a0ffe8;
  font-weight: 600;
  min-width: 80px;
}

.summary-range-head {
  color: #a0ffe8;
  font-weight: 600;
  font-size: 0.85rem;
  display: flex;
  justify-content: space-between;
  margin-bottom: 4px;
}

.summary-range-total {
  color: #fff;
}

.summary-end-row {
  display: flex;
  align-items: center;
  gap: 4px;
  flex-wrap: wrap;
  margin-bottom: 4px;
}

.summary-end-lbl {
  color: #6a9990;
  font-size: 0.75rem;
  min-width: 44px;
}

.summary-arrow-chip {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 26px;
  height: 26px;
  border-radius: 50%;
  font-size: 0.72rem;
  font-weight: 700;
  border: 1px solid rgba(255,255,255,0.15);
}

.summary-end-score {
  color: #d0f0ea;
  font-size: 0.8rem;
  margin-left: 4px;
}

.summary-grand-total {
  color: #a0ffe8;
  font-weight: 700;
  font-size: 1rem;
  text-align: right;
  margin-top: 8px;
  padding-top: 8px;
  border-top: 1px solid rgba(255,255,255,0.1);
}

.summary-message {
  border-radius: 8px;
  padding: 12px 14px;
  font-size: 0.83rem;
  line-height: 1.5;
  margin-bottom: 4px;
}

.msg-comp {
  background: rgba(244, 180, 0, 0.12);
  border: 1px solid rgba(244, 180, 0, 0.35);
  color: #f4d060;
}

.msg-practice {
  background: rgba(52, 152, 219, 0.12);
  border: 1px solid rgba(52, 152, 219, 0.35);
  color: #a8d8f0;
}

.summary-actions {
  display: flex;
  gap: 10px;
}

.summary-cancel-btn {
  background: #2d5a50;
  color: #d0f0ea;
  border: none;
  border-radius: 8px;
  padding: 12px 20px;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
}

.summary-cancel-btn:hover:not(:disabled) {
  background: #3d7a6a;
}

.summary-ok-msg {
  color: #d0f0ea;
  text-align: center;
  font-size: 0.9rem;
  margin-top: 8px;
}
</style>
