<script>
export default {
  name: 'Details',

  data() {
    return {
      rounds: [],
      archers: [],
      divisions: [],
      ageClasses: [],
      equivalentRounds: [],
      categories: [],
      competitions: [],
      loadError: '',
      selectedArcherId: '',
      selectedRoundId: '',
      selectedAgeClassId: '',
      selectedDivisionId: '',
      isCompetition: false,
      selectedCompId: '',
    }
  },

  computed: {
    selectedArcher() {
      return this.archers.find((a) => a.archer_id == this.selectedArcherId) ?? null
    },
    validRounds() {
      if (!this.selectedArcher) return []
      return this.rounds.filter(
        (r) => this.validAgeClassesFor(this.selectedArcher, Number(r.round_def_id)).length > 0,
      )
    },
    validAgeClasses() {
      if (!this.selectedArcher || !this.selectedRoundId) return []
      return this.validAgeClassesFor(this.selectedArcher, Number(this.selectedRoundId))
    },
    validDivisions() {
      if (!this.selectedRoundId || !this.selectedAgeClassId) return []
      return this.validDivisionsFor(Number(this.selectedRoundId), Number(this.selectedAgeClassId))
    },
    canSubmit() {
      return (
        this.selectedArcher &&
        this.selectedRoundId &&
        this.selectedAgeClassId &&
        this.selectedDivisionId &&
        (!this.isCompetition || this.selectedCompId)
      )
    },
  },

  watch: {
    validAgeClasses(classes) {
      if (classes.length === 1) this.selectedAgeClassId = String(classes[0].age_class_id)
    },
    validDivisions(divs) {
      if (divs.length === 1) this.selectedDivisionId = String(divs[0].division_id)
    },
    selectedArcherId() {
      this.selectedRoundId = ''
      this.selectedAgeClassId = ''
      this.selectedDivisionId = ''
    },
    selectedRoundId() {
      this.selectedAgeClassId = ''
      this.selectedDivisionId = ''
    },
    selectedAgeClassId() {
      this.selectedDivisionId = ''
    },
    isCompetition(val) {
      if (!val) this.selectedCompId = ''
    },
  },

  methods: {
    async fetchData() {
      this.loadError = ''
      try {
        const res = await fetch('/apis.php?query=setup_data')
        if (!res.ok) {
          const text = await res.text()
          this.loadError = `Server error ${res.status}: ${text}`
          return
        }
        const data = await res.json()
        this.rounds = data.rounds ?? []
        this.archers = data.archers ?? []
        this.divisions = data.divisions ?? []
        this.ageClasses = data.age_classes ?? []
        this.categories = data.categories ?? []
        this.equivalentRounds = data.equivalent_rounds ?? []
        this.competitions = data.competitions ?? []
      } catch (err) {
        this.loadError = `Could not reach PHP server — is it running? (${err.message})`
      }
    },

    categoryIdsForRound(roundId) {
      const asEquivalent = this.equivalentRounds
        .filter((er) => Number(er.equivalent_round_id) === roundId)
        .map((er) => Number(er.category_id))
      if (asEquivalent.length > 0) return new Set(asEquivalent)

      const isBase = this.equivalentRounds.some((er) => Number(er.base_round_id) === roundId)
      if (isBase) {
        const mappedCats = new Set(this.equivalentRounds.map((er) => Number(er.category_id)))
        return new Set(
          this.categories.map((c) => Number(c.category_id)).filter((id) => !mappedCats.has(id)),
        )
      }
      return null
    },

    validAgeClassesFor(archer, roundId) {
      const age = new Date().getFullYear() - Number(archer.birth_year)
      const catIds = this.categoryIdsForRound(roundId)
      return this.ageClasses.filter((ac) => {
        if (ac.gender !== archer.gender) return false
        if (ac.min_age !== null && age < Number(ac.min_age)) return false
        if (ac.max_age !== null && age > Number(ac.max_age)) return false
        if (catIds !== null) {
          return this.categories.some(
            (c) =>
              catIds.has(Number(c.category_id)) &&
              Number(c.age_class_id) === Number(ac.age_class_id),
          )
        }
        return true
      })
    },

    validDivisionsFor(roundId, ageClassId) {
      const catIds = this.categoryIdsForRound(roundId)
      if (catIds === null) return this.divisions
      return this.divisions.filter((d) =>
        this.categories.some(
          (c) =>
            catIds.has(Number(c.category_id)) &&
            Number(c.division_id) === Number(d.division_id) &&
            Number(c.age_class_id) === Number(ageClassId),
        ),
      )
    },

    submit() {
      if (!this.canSubmit) return
      const selectedRound = this.rounds.find((r) => r.round_def_id == this.selectedRoundId)
      const selectedAgeClass = this.ageClasses.find((ac) => ac.age_class_id == this.selectedAgeClassId)
      const selectedDivision = this.divisions.find((d) => d.division_id == this.selectedDivisionId)
      this.$router.push({
        path: '/test',
        query: {
          round_id: this.selectedRoundId,
          round_name: selectedRound?.round_name ?? '',
          comp_id: this.isCompetition ? this.selectedCompId : null,
          archers: JSON.stringify([
            {
              archer_id: this.selectedArcher.archer_id,
              name_given: this.selectedArcher.name_given,
              name_surname: this.selectedArcher.name_surname,
              division_id: Number(this.selectedDivisionId),
              division_name: selectedDivision?.division_name ?? '',
              age_class_id: Number(this.selectedAgeClassId),
              age_class_name: selectedAgeClass?.class_name ?? '',
              gender: this.selectedArcher.gender,
              birth_year: this.selectedArcher.birth_year,
            },
          ]),
        },
      })
    },
  },

  mounted() {
    this.fetchData()
  },
}
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

      <!-- Archer debug info -->
      <div v-if="selectedArcher" class="archer-info mb-4">
        {{ selectedArcher.name_given }} {{ selectedArcher.name_surname }},
        {{ selectedArcher.gender === 'M' ? 'Male' : 'Female' }},
        {{ selectedArcher.birth_year }} – {{ new Date().getFullYear() - selectedArcher.birth_year }}
      </div>

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
          <!-- Competition toggle -->
          <div class="d-flex align-items-center gap-2 mb-3">
            <input id="isComp" v-model="isCompetition" type="checkbox" class="form-check-input mt-0" />
            <label for="isComp" class="text-white mb-0">This is a competition</label>
          </div>
          <select v-if="isCompetition" v-model="selectedCompId" class="form-select mb-4">
            <option value="" disabled>-- Select a competition --</option>
            <option v-for="c in competitions" :key="c.comp_id" :value="c.comp_id">
              {{ c.comp_name }} ({{ c.comp_date }})
            </option>
          </select>
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

.archer-info {
  background: rgba(0, 0, 0, 0.15);
  color: #d0f0ea;
  font-size: 0.8rem;
  padding: 6px 10px;
  border-radius: 4px;
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
