<script>
export default {
  name: 'Entries',

  data() {
    return {
      ARROW_VALUES: ['X', '10', '9', '8', '7', '6', '5', '4', '3', '2', '1', 'M'],
      ARROWS_PER_END: 6,
      roundId: 0,
      archer: null,
      ranges: [],
      loadError: '',
      activeRangeIdx: 0,
      scores: [],
      showSummary: false,
      submitting: false,
      submitError: '',
      submitDone: false,
      picking: null,
    }
  },

  computed: {
    activeRange() {
      return this.ranges[this.activeRangeIdx] ?? null
    },
    activeRangeScores() {
      return this.scores[this.activeRangeIdx] ?? []
    },
    grandTotal() {
      return this.scores.reduce(
        (sum, rangeEnds) => sum + rangeEnds.reduce((s, end) => s + this.endTotal(end), 0),
        0,
      )
    },
    allComplete() {
      return (
        this.scores.length > 0 &&
        this.scores.every((rangeEnds) => rangeEnds.every((end) => end.every((s) => s !== null)))
      )
    },
    isComp() {
      return !!(this.$route.query.comp_id && this.$route.query.comp_id !== 'null')
    },
  },

  watch: {
    ranges: {
      handler: 'ensureScores',
      immediate: true,
    },
  },

  methods: {
    async fetchRanges() {
      try {
        const res = await fetch(`/apis.php?query=ranges_for_round&round_id=${this.roundId}`)
        if (!res.ok) {
          this.loadError = `Server error ${res.status}`
          return
        }
        const data = await res.json()
        this.ranges = data
      } catch (err) {
        this.loadError = `Could not reach server (${err.message})`
      }
    },

    ensureScores() {
      this.scores = this.ranges.map((rng) =>
        Array.from({ length: Number(rng.num_ends) }, () => Array(this.ARROWS_PER_END).fill(null)),
      )
    },

    numericVal(s) {
      if (s === null) return 0
      if (s === 'X') return 10
      if (s === 'M') return 0
      return Number(s)
    },

    endTotal(endArrows) {
      return endArrows.reduce((sum, s) => sum + this.numericVal(s), 0)
    },

    runningTotal(endIdx) {
      let total = 0
      for (let e = 0; e <= endIdx; e++) {
        total += this.endTotal(this.activeRangeScores[e] ?? [])
      }
      return total
    },

    rangeTotal(rangeIdx) {
      return (this.scores[rangeIdx] ?? []).reduce((s, end) => s + this.endTotal(end), 0)
    },

    async acceptSubmit() {
      this.submitting = true
      this.submitError = ''
      const payload = {
        archer_id: this.archer.archer_id,
        round_def_id: this.roundId,
        division_id: this.archer.division_id,
        age_class_id: this.archer.age_class_id,
        is_competition: this.isComp,
        comp_id: this.isComp ? Number(this.$route.query.comp_id) : null,
        ranges: this.ranges.map((rng, idx) => ({
          distance: rng.distance,
          target_size_cm: rng.target_size_cm,
          ends: this.scores[idx],
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
          this.submitError = data.error ?? `Server error ${res.status}`
        } else {
          this.submitDone = true
        }
      } catch (err) {
        this.submitError = `Could not reach server (${err.message})`
      } finally {
        this.submitting = false
      }
    },

    openPicker(endIdx, arrowIdx) {
      this.picking = { endIdx, arrowIdx }
    },

    pickScore(val) {
      if (!this.picking) return
      const { endIdx, arrowIdx } = this.picking
      this.scores[this.activeRangeIdx][endIdx][arrowIdx] = val
      this.picking = null
    },

    closePicker() {
      this.picking = null
    },

    arrowLabel(s) {
      return s === null ? '—' : s
    },

    arrowClass(s) {
      if (s === null) return 'arrow-empty'
      if (s === 'X' || s === '10') return 'arrow-gold'
      if (s === '9' || s === '8') return 'arrow-red'
      if (s === '7' || s === '6') return 'arrow-blue'
      if (s === '5' || s === '4') return 'arrow-black'
      if (s === '3' || s === '2' || s === '1') return 'arrow-white'
      return 'arrow-miss'
    },
  },

  mounted() {
    this.roundId = Number(this.$route.query.round_id)
    try {
      this.archer = JSON.parse(this.$route.query.archers)[0]
    } catch {
      this.archer = null
    }
    this.fetchRanges()
  },
}
</script>

<template>
  <div v-if="loadError" class="alert alert-danger m-3">{{ loadError }}</div>
  <div v-else-if="!ranges.length" class="text-center text-white pt-5">Loading…</div>
  <div v-else class="scoring-shell d-flex flex-column flex-md-row min-vh-100">
    <nav class="range-sidebar d-flex flex-row flex-md-column gap-2 p-3">
      <div class="d-none d-md-block fw-bold mb-1">Ranges</div>
      <button
        v-for="(rng, idx) in ranges"
        :key="`${rng.distance}-${rng.target_size_cm}`"
        class="range-btn"
        :class="{ active: idx === activeRangeIdx }"
        @click="activeRangeIdx = idx"
      >
        <span>{{ rng.distance }}m</span>
        <span class="d-none d-md-block">{{ rng.num_ends }} ends</span>
        <span class="d-none d-md-block">{{ rng.target_size_cm }}cm face</span>
      </button>
      <div class="mt-auto d-none d-md-block">
        <div class="p-2 text-center">
          <div>Total</div>
          <div>{{ grandTotal }}</div>
        </div>
      </div>
    </nav>
    <div class="d-flex flex-column flex-grow-1">
      <div class="debug-bar" v-if="archer">
        {{ archer.name_given }} {{ archer.name_surname }},
        {{ archer.gender === 'M' ? 'Male' : 'Female' }},
        {{ archer.birth_year }} – {{ new Date().getFullYear() - archer.birth_year }}
        — {{ $route.query.round_name }}, {{ archer.age_class_name }}, {{ archer.division_name }},
        {{ ($route.query.comp_id && $route.query.comp_id !== 'null') ? 'Competition' : 'No competition' }}
      </div>
      <main class="flex-grow-1 p-3">
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">
          <span class="fw-bold" v-if="archer">
            {{ archer.name_given }} {{ archer.name_surname }}
          </span>
          <span class="badge bg-secondary" v-if="activeRange">
            {{ activeRange.distance }}m — {{ activeRange.num_ends }} ends
          </span>
          <span class="d-md-none">Total: {{ grandTotal }}</span>
        </div>
        <div
          v-for="(endArrows, ei) in activeRangeScores"
          :key="ei"
          class="border mb-3"
        >
          <div class="fw-semibold small px-3 py-1 border-bottom">End {{ ei + 1 }}</div>
          <div class="d-flex align-items-center gap-2 p-2 flex-wrap">
            <div class="d-flex gap-1 flex-wrap">
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
            <div class="d-flex align-items-center gap-2 ms-auto">
              <span class="end-total-box">{{ endTotal(endArrows) }}</span>
              <span class="running-total">{{ runningTotal(ei) }}</span>
            </div>
          </div>
        </div>
        <div v-if="allComplete" class="p-3">
          <button class="btn btn-secondary w-100" @click="showSummary = true">
            Submit Session
          </button>
        </div>
      </main>
    </div>
    <Teleport to="body">
      <div v-if="picking" class="picker-overlay" @click.self="closePicker">
        <div class="picker-modal">
          <div class="fw-semibold mb-3 text-center">Select score</div>
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
          <button class="btn btn-outline-secondary w-100" @click="closePicker">Cancel</button>
        </div>
      </div>
    </Teleport>
    <Teleport to="body">
      <div v-if="showSummary" class="picker-overlay">
        <div class="summary-modal">

          <!-- Success state -->
          <template v-if="submitDone">
            <div class="fs-5 fw-bold mb-3 text-center">Submitted!</div>
            <p class="text-center small mt-2">
              {{ isComp
                ? 'Your competition entry is pending review by a verified recorder.'
                : 'Your practice round has been saved to your profile.' }}
            </p>
            <button class="btn btn-secondary w-100 mt-3" @click="$router.push('/')">
              Close
            </button>
          </template>
          <template v-else>
            <div class="fs-5 fw-bold mb-3 text-center">Session Summary</div>
            <div class="p-3 mb-3 border" v-if="archer">
              <div class="d-flex gap-2 small py-1">
                <span class="summary-lbl">Archer</span>
                <span>{{ archer.name_given }} {{ archer.name_surname }},
                  {{ archer.gender === 'M' ? 'Male' : 'Female' }},
                  {{ archer.birth_year }} – {{ new Date().getFullYear() - archer.birth_year }}</span>
              </div>
              <div class="d-flex gap-2 small py-1">
                <span class="summary-lbl">Round</span>
                <span>{{ $route.query.round_name }}</span>
              </div>
              <div class="d-flex gap-2 small py-1">
                <span class="summary-lbl">Class</span>
                <span>{{ archer.age_class_name }}</span>
              </div>
              <div class="d-flex gap-2 small py-1">
                <span class="summary-lbl">Division</span>
                <span>{{ archer.division_name }}</span>
              </div>
              <div class="d-flex gap-2 small py-1">
                <span class="summary-lbl">Competition</span>
                <span>{{ isComp ? 'Yes' : 'No' }}</span>
              </div>
            </div>
            <div class="p-3 mb-3 border">
              <div
                v-for="(rng, ri) in ranges"
                :key="`${rng.distance}-${rng.target_size_cm}`"
                class="mb-2"
              >
                <div class="fw-semibold small d-flex justify-content-between mb-1">
                  {{ rng.distance }}m — {{ rng.target_size_cm }}cm face
                  <span>{{ rangeTotal(ri) }} pts</span>
                </div>
                <div
                  v-for="(endArrows, ei) in scores[ri]"
                  :key="ei"
                  class="d-flex align-items-center gap-1 flex-wrap mb-1"
                >
                  <span class="summary-end-lbl">End {{ ei + 1 }}</span>
                  <span
                    v-for="(s, ai) in endArrows"
                    :key="ai"
                    class="summary-arrow-chip"
                    :class="arrowClass(s)"
                  >{{ s }}</span>
                  <span class="small ms-1">= {{ endTotal(endArrows) }}</span>
                </div>
              </div>
              <div class="fw-bold text-end mt-2 pt-2 border-top">Grand Total: {{ grandTotal }}</div>
            </div>
            <div class="p-3 small mb-1 border">
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
            <div class="d-flex gap-2 mt-3">
              <button class="btn btn-outline-secondary text-nowrap" @click="showSummary = false" :disabled="submitting">
                Cancel
              </button>
              <button class="btn btn-secondary flex-grow-1" @click="acceptSubmit" :disabled="submitting">
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
  .range-sidebar {
    overflow-x: auto;
    flex-shrink: 0;
  }
  .range-btn.active {
    font-weight: 700;
    outline: 2px solid;
  }
  .debug-bar {
    font-size: 0.78rem;
    padding: 6px 14px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    flex-shrink: 0;
  }
  .end-total-box {
    font-weight: 700;
    font-size: 1rem;
    padding: 4px 10px;
    min-width: 36px;
    text-align: center;
    border: 1px solid;
  }
  .running-total {
    font-size: 0.85rem;
    opacity: 0.6;
    min-width: 28px;
    text-align: right;
  }
  .arrow-empty  { background: #3a5550; color: #6a9990; }
  .arrow-gold   { background: #f0c040; color: #2a1800; border-color: #e0a000; }
  .arrow-red    { background: #c0392b; color: #fff;    border-color: #922b21; }
  .arrow-blue   { background: #2471a3; color: #fff;    border-color: #1a5276; }
  .arrow-black  { background: #2c3e50; color: #fff;    border-color: #1a252f; }
  .arrow-white  { background: #ecf0f1; color: #2c3e50; border-color: #bdc3c7; }
  .arrow-miss   { background: #1a2e2b; color: #e74c3c; border-color: #e74c3c; }
  .picker-overlay {
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.6);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
  }
  .picker-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 8px;
    margin-bottom: 14px;
  }
  .summary-modal {
    padding: 24px;
    width: min(680px, 95vw);
    max-height: 90vh;
    overflow-y: auto;
    border: 1px solid;
    background: white;
  }
  .summary-lbl {
    font-weight: 600;
    min-width: 80px;
  }
  .summary-end-lbl {
    font-size: 0.75rem;
    min-width: 44px;
  }
  .summary-arrow-chip {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 26px;
    height: 26px;
    font-size: 0.72rem;
    font-weight: 700;
    border: 1px solid;
  }
</style>