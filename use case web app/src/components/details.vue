<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const rounds = ref([])
const archers = ref([])
const divisions = ref([])
const ageClasses = ref([])
const equivalentRounds = ref([])
const categories = ref([])
const loadError = ref('')

const selectedArcherId = ref('')
const selectedRoundId = ref('')
const selectedAgeClassId = ref('')
const selectedDivisionId = ref('')

async function fetchData() {
  loadError.value = ''
  try {
    const res = await fetch('/apis.php?query=setup_data')
    if (!res.ok) {
      const text = await res.text()
      loadError.value = `Server error ${res.status}: ${text}`
      return
    }
    const data = await res.json()
    rounds.value = data.rounds ?? []
    archers.value = data.archers ?? []
    divisions.value = data.divisions ?? []
    ageClasses.value = data.age_classes ?? []
    categories.value = data.categories ?? []
    equivalentRounds.value = data.equivalent_rounds ?? []
  } catch (err) {
    loadError.value = `Could not reach PHP server — is it running? (${err.message})`
  }
}

// ── Selected archer object ────────────────────────────────────────────────────
const selectedArcher = computed(() =>
  archers.value.find((a) => a.archer_id == selectedArcherId.value) ?? null,
)

// ── Core: valid category IDs for a given round ────────────────────────────────
function categoryIdsForRound(roundId) {
  // Case A: round is an equivalent round
  const asEquivalent = equivalentRounds.value
    .filter((er) => Number(er.equivalent_round_id) === roundId)
    .map((er) => Number(er.category_id))
  if (asEquivalent.length > 0) return new Set(asEquivalent)

  // Case B: round is a base round
  const isBase = equivalentRounds.value.some((er) => Number(er.base_round_id) === roundId)
  if (isBase) {
    const mappedCats = new Set(equivalentRounds.value.map((er) => Number(er.category_id)))
    return new Set(
      categories.value.map((c) => Number(c.category_id)).filter((id) => !mappedCats.has(id)),
    )
  }

  // Case C: no restriction
  return null
}

// ── Valid age classes for an archer on a given round ─────────────────────────
function validAgeClassesFor(archer, roundId) {
  const age = new Date().getFullYear() - Number(archer.birth_year)
  const catIds = categoryIdsForRound(roundId)

  return ageClasses.value.filter((ac) => {
    if (ac.gender !== archer.gender) return false
    if (ac.min_age !== null && age < Number(ac.min_age)) return false
    if (ac.max_age !== null && age > Number(ac.max_age)) return false
    if (catIds !== null) {
      return categories.value.some(
        (c) =>
          catIds.has(Number(c.category_id)) &&
          Number(c.age_class_id) === Number(ac.age_class_id),
      )
    }
    return true
  })
}

// ── Valid divisions for a round + age class ───────────────────────────────────
function validDivisionsFor(roundId, ageClassId) {
  const catIds = categoryIdsForRound(roundId)
  if (catIds === null) return divisions.value
  return divisions.value.filter((d) =>
    categories.value.some(
      (c) =>
        catIds.has(Number(c.category_id)) &&
        Number(c.division_id) === Number(d.division_id) &&
        Number(c.age_class_id) === Number(ageClassId),
    ),
  )
}

// ── Filtered options ──────────────────────────────────────────────────────────
const validRounds = computed(() => {
  if (!selectedArcher.value) return []
  return rounds.value.filter(
    (r) => validAgeClassesFor(selectedArcher.value, Number(r.round_def_id)).length > 0,
  )
})

const validAgeClasses = computed(() => {
  if (!selectedArcher.value || !selectedRoundId.value) return []
  return validAgeClassesFor(selectedArcher.value, Number(selectedRoundId.value))
})

const validDivisions = computed(() => {
  if (!selectedRoundId.value || !selectedAgeClassId.value) return []
  return validDivisionsFor(Number(selectedRoundId.value), Number(selectedAgeClassId.value))
})

// ── Auto-select when only one option ─────────────────────────────────────────
watch(validAgeClasses, (classes) => {
  if (classes.length === 1) selectedAgeClassId.value = String(classes[0].age_class_id)
})

watch(validDivisions, (divs) => {
  if (divs.length === 1) selectedDivisionId.value = String(divs[0].division_id)
})

// ── Reset cascade when selections change ─────────────────────────────────────
watch(selectedArcherId, () => {
  selectedRoundId.value = ''
  selectedAgeClassId.value = ''
  selectedDivisionId.value = ''
})

watch(selectedRoundId, () => {
  selectedAgeClassId.value = ''
  selectedDivisionId.value = ''
})

watch(selectedAgeClassId, () => {
  selectedDivisionId.value = ''
})

// ── Submit ────────────────────────────────────────────────────────────────────
const canSubmit = computed(
  () =>
    selectedArcher.value &&
    selectedRoundId.value &&
    selectedAgeClassId.value &&
    selectedDivisionId.value,
)

function submit() {
  if (!canSubmit.value) return
  router.push({
    path: '/test',
    query: {
      round_id: selectedRoundId.value,
      archers: JSON.stringify([
        {
          archer_id: selectedArcher.value.archer_id,
          name_given: selectedArcher.value.name_given,
          name_surname: selectedArcher.value.name_surname,
          division_id: Number(selectedDivisionId.value),
          age_class_id: Number(selectedAgeClassId.value),
          gender: selectedArcher.value.gender,
          birth_year: selectedArcher.value.birth_year,
        },
      ]),
    },
  })
}

onMounted(fetchData)
</script>

<template>
  <div class="d-flex justify-content-center pt-4 px-2">
    <div class="selection-card p-4">
      <div v-if="loadError" class="alert alert-danger mb-3" style="font-size: 0.85rem">
        {{ loadError }}
      </div>

      <!-- Step 1: Archer -->
      <h5 class="text-center fw-bold text-white mb-3">Choose archer</h5>
      <select v-model="selectedArcherId" class="form-select mb-4">
        <option value="" disabled>-- Select an archer --</option>
        <option v-for="a in archers" :key="a.archer_id" :value="a.archer_id">
          {{ a.name_given }} {{ a.name_surname }}
        </option>
      </select>

      <!-- Steps 2–4: shown once archer is selected -->
      <template v-if="selectedArcher">
        <!-- Round -->
        <h5 class="text-center fw-bold text-white mb-3">Choose round</h5>
        <select v-model="selectedRoundId" class="form-select mb-4">
          <option value="" disabled>-- Select a round --</option>
          <option v-for="r in validRounds" :key="r.round_def_id" :value="r.round_def_id">
            {{ r.round_name }} ({{ r.arrow_count }} arrows)
          </option>
        </select>

        <!-- Class + Division: shown once round is selected -->
        <template v-if="selectedRoundId">
          <h5 class="text-center fw-bold text-white mb-3">Choose class &amp; division</h5>
          <div class="d-flex gap-2 mb-4">
            <select v-model="selectedAgeClassId" class="form-select">
              <option value="" disabled>-- Class --</option>
              <option
                v-for="ac in validAgeClasses"
                :key="ac.age_class_id"
                :value="ac.age_class_id"
              >
                {{ ac.class_name }}
              </option>
            </select>
            <select v-model="selectedDivisionId" class="form-select" :disabled="!selectedAgeClassId">
              <option value="" disabled>-- Division --</option>
              <option v-for="d in validDivisions" :key="d.division_id" :value="d.division_id">
                {{ d.division_name }}
              </option>
            </select>
          </div>
        </template>
      </template>

      <button class="done-btn w-100" :disabled="!canSubmit" @click="submit">Done</button>
    </div>
  </div>
</template>

<style scoped>
.selection-card {
  background-color: #2d8a7a;
  border-radius: 8px;
  width: 600px;
  max-width: 95vw;
}

.done-btn {
  background-color: #1a5c50;
  color: white;
  font-weight: 500;
  border: none;
  padding: 10px;
  border-radius: 6px;
  cursor: pointer;
}

.done-btn:hover:not(:disabled) {
  background-color: #12453d;
}

.done-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>
