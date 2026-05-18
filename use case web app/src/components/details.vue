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

const selectedRoundId = ref('')
const selectedArcherId = ref('')
const archerList = ref([])
const loadError = ref('')

// Single request — server joins round_def with range_def for arrow_count
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
    console.log('setup_data:', {
      rounds: data.rounds?.length,
      archers: data.archers?.length,
      divisions: data.divisions?.length,
      age_classes: data.age_classes?.length,
      categories: data.categories?.length,
      equivalent_rounds: data.equivalent_rounds?.length,
    })
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

// ── Arrow count per round ────────────────────────────────────────────────────
// arrow_count is now precomputed by the server-side JOIN in setup_data
const arrowCountByRound = computed(() => {
  const map = {}
  rounds.value.forEach((r) => {
    if (Number(r.arrow_count) > 0) map[Number(r.round_def_id)] = Number(r.arrow_count)
  })
  return map
})

// ── Valid categories for the selected round ──────────────────────────────────
//
// Three cases for any selected round:
//
//  A) Round appears as equivalent_round_id in the table
//     → only the categories listed there shoot this round
//
//  B) Round appears as base_round_id but NOT as equivalent_round_id
//     → categories that shoot this base round are those WITHOUT any entry in
//       the table (they have no shorter equivalent, so they shoot the base)
//
//  C) Round doesn't appear in the table at all (Australian club rounds, etc.)
//     → no restriction; any category is valid  (represented as null)
//
const validCategoryIdsForRound = computed(() => {
  if (!selectedRoundId.value) return null

  const roundId = Number(selectedRoundId.value)

  // Case A
  const asEquivalent = equivalentRounds.value
    .filter((er) => Number(er.equivalent_round_id) === roundId)
    .map((er) => Number(er.category_id))
  if (asEquivalent.length > 0) return new Set(asEquivalent)

  // Case B
  const isBase = equivalentRounds.value.some((er) => Number(er.base_round_id) === roundId)
  if (isBase) {
    const mappedCats = new Set(equivalentRounds.value.map((er) => Number(er.category_id)))
    return new Set(
      categories.value.map((c) => Number(c.category_id)).filter((id) => !mappedCats.has(id)),
    )
  }

  // Case C
  return null
})

// ── Per-archer helpers ────────────────────────────────────────────────────────

// Age classes valid for the selected round AND this specific archer's gender/age
function archerValidAgeClasses(archer) {
  const age = new Date().getFullYear() - Number(archer.birth_year)
  const catIds = validCategoryIdsForRound.value // null = no restriction

  return ageClasses.value.filter((ac) => {
    if (ac.gender !== archer.gender) return false
    if (ac.min_age !== null && age < Number(ac.min_age)) return false
    if (ac.max_age !== null && age > Number(ac.max_age)) return false

    if (catIds !== null) {
      // At least one valid category must link this age class to the round
      const ok = categories.value.some(
        (c) =>
          catIds.has(Number(c.category_id)) && Number(c.age_class_id) === Number(ac.age_class_id),
      )
      if (!ok) return false
    }
    return true
  })
}

// Divisions valid for the selected round AND this archer's currently selected age class
function archerValidDivisions(archer) {
  const catIds = validCategoryIdsForRound.value // null = no restriction

  if (catIds === null) return divisions.value

  return divisions.value.filter((d) => {
    // There must be a valid category that combines this division with the archer's age class
    return categories.value.some(
      (c) =>
        catIds.has(Number(c.category_id)) &&
        Number(c.division_id) === Number(d.division_id) &&
        Number(c.age_class_id) === Number(archer.age_class_id),
    )
  })
}

// Default age class: most specific (highest min_age) valid match for the archer
function defaultAgeClassId(archer) {
  const valid = archerValidAgeClasses(archer)
  return (
    valid.sort((a, b) => (Number(b.min_age) || -1) - (Number(a.min_age) || -1))[0]?.age_class_id ??
    null
  )
}

// Default division: archer's stored default if valid, otherwise first valid option
function defaultDivisionId(archer, ageClassId) {
  const fake = { ...archer, age_class_id: ageClassId }
  const valid = archerValidDivisions(fake)
  const stored = valid.find((d) => Number(d.division_id) === Number(archer.division_id))
  return stored ? Number(archer.division_id) : (Number(valid[0]?.division_id) ?? null)
}

// ── When the round changes, reset any selection that is no longer valid ───────
watch(selectedRoundId, () => {
  archerList.value.forEach((archer) => {
    const validAC = archerValidAgeClasses(archer).map((ac) => Number(ac.age_class_id))
    if (!validAC.includes(Number(archer.age_class_id))) {
      archer.age_class_id = validAC[0] ?? null
    }
    const validDiv = archerValidDivisions(archer).map((d) => Number(d.division_id))
    if (!validDiv.includes(Number(archer.division_id))) {
      archer.division_id = validDiv[0] ?? null
    }
  })
})

// When an archer's age class changes, reset division if it is no longer valid
function onAgeClassChange(archer) {
  const validDiv = archerValidDivisions(archer).map((d) => Number(d.division_id))
  if (!validDiv.includes(Number(archer.division_id))) {
    archer.division_id = validDiv[0] ?? null
  }
}

// ── Archer list management ────────────────────────────────────────────────────
function addArcher() {
  if (!selectedArcherId.value) return
  const archer = archers.value.find((a) => a.archer_id == selectedArcherId.value)
  if (!archer || archerList.value.find((a) => a.archer_id == archer.archer_id)) return

  const ageClassId = defaultAgeClassId(archer)
  const divisionId = defaultDivisionId(archer, ageClassId)

  archerList.value.push({
    archer_id: archer.archer_id,
    name_given: archer.name_given,
    name_surname: archer.name_surname,
    division_id: divisionId,
    age_class_id: ageClassId,
    gender: archer.gender,
    birth_year: archer.birth_year,
  })
  selectedArcherId.value = ''
}

function removeArcher(id) {
  archerList.value = archerList.value.filter((a) => a.archer_id !== id)
}

function submit() {
  if (!selectedRoundId.value || archerList.value.length === 0) return
  router.push({
    path: '/test',
    query: {
      round_id: selectedRoundId.value,
      archers: JSON.stringify(archerList.value),
    },
  })
}

onMounted(fetchData)
</script>

<template>
  <div class="d-flex justify-content-center pt-4 px-2">
    <div class="selection-card p-4">
      <div v-if="loadError" class="alert alert-danger mb-3" style="font-size:0.85rem;">
        {{ loadError }}
      </div>
      <h5 class="text-center fw-bold text-white mb-3">Choose round</h5>
      <select v-model="selectedRoundId" class="form-select mb-4">
        <option value="" disabled>-- Select a round --</option>
        <option
          v-for="r in rounds"
          :key="r.round_def_id"
          :value="r.round_def_id"
          :disabled="!arrowCountByRound[r.round_def_id]"
        >
          {{
            arrowCountByRound[r.round_def_id]
              ? `${r.round_name} (${arrowCountByRound[r.round_def_id]} arrows)`
              : `${r.round_name} (no ranges defined)`
          }}
        </option>
      </select>

      <h5 class="text-center fw-bold text-white mb-3">Choose archer</h5>
      <select v-model="selectedArcherId" class="form-select mb-3" @change="addArcher">
        <option value="" disabled>-- Select an archer --</option>
        <option v-for="a in archers" :key="a.archer_id" :value="a.archer_id">
          {{ a.name_given }} {{ a.name_surname }}
        </option>
      </select>

      <div
        v-for="archer in archerList"
        :key="archer.archer_id"
        class="d-flex gap-2 mb-2 align-items-center flex-wrap"
      >
        <div class="name-cell px-2 py-1">{{ archer.name_given }}</div>
        <div class="name-cell px-2 py-1">{{ archer.name_surname }}</div>

        <!-- Event (age class) — filtered by round + archer's gender/age -->
        <select
          v-model="archer.age_class_id"
          class="form-select flex-grow-1"
          @change="onAgeClassChange(archer)"
        >
          <option
            v-for="ac in archerValidAgeClasses(archer)"
            :key="ac.age_class_id"
            :value="ac.age_class_id"
          >
            {{ ac.class_name }}
          </option>
        </select>

        <!-- Equipment (division) — filtered by round + archer's selected age class -->
        <select v-model="archer.division_id" class="form-select flex-grow-1">
          <option
            v-for="d in archerValidDivisions(archer)"
            :key="d.division_id"
            :value="d.division_id"
          >
            {{ d.division_name }}
          </option>
        </select>

        <button class="remove-btn" @click="removeArcher(archer.archer_id)">
          <span class="text-danger fw-bold">X</span>
        </button>
      </div>

      <button
        class="done-btn w-100 mt-3"
        :disabled="!selectedRoundId || archerList.length === 0"
        @click="submit"
      >
        Done
      </button>
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

.name-cell {
  background: white;
  border: 1px solid #ccc;
  border-radius: 4px;
  min-width: 85px;
  white-space: nowrap;
  font-size: 0.95rem;
}

.remove-btn {
  background-color: #3a2020;
  border: 1px solid #555;
  border-radius: 4px;
  width: 38px;
  height: 38px;
  flex-shrink: 0;
  cursor: pointer;
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
