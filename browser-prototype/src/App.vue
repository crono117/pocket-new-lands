<script setup>
import { ref, reactive } from 'vue'
import { TresCanvas } from '@tresjs/core'
import World from './World.vue'
const state = reactive({ realm: 'hearth', paused: false, effects: true, zoom: 1, discovered: false, steps: 0, status: 'The sanctuary is quiet. Find the violet gate.' })
const move = reactive({ x: 0, y: 0 })
const world = ref()
function portal() { world.value?.travel() }
function reset() { world.value?.reset() }
</script>
<template>
<main>
 <div class="viewport">
  <TresCanvas clear-color="#0c1325" :dpr="[1, 1.5]" :shadows="false">
   <World ref="world" :state="state" :move="move" />
  </TresCanvas>
 </div>
 <header class="topbar"><div><span class="eyebrow">POCKET NEW LANDS</span><h1>{{ state.realm === 'hearth' ? 'The Last Hearth' : 'The Ash Meridian' }}</h1></div><div class="realm"><i></i>{{ state.realm === 'hearth' ? 'Sanctuary' : 'Beyond the ward' }}</div></header>
 <aside class="journal"><span class="eyebrow">KEEPER’S JOURNAL</span><h2>{{ state.realm === 'hearth' ? 'A home between worlds' : 'A borrowed tomorrow' }}</h2><p>{{ state.realm === 'hearth' ? 'A caged sun warms the chapel. Travelers from broken histories gather at its edge.' : 'The observatory is silent. Its shattered lens remembers a sun that has not yet died.' }}</p><div class="divider"></div><span class="eyebrow">EXPLORATION</span><p class="status" aria-live="polite">{{ state.status }}</p><button @click="portal">{{ state.realm === 'hearth' ? 'Enter nearby portal' : 'Return to sanctuary' }}</button><small>The gate opens when you stand close.</small></aside>
 <section class="bottom"><div class="controls"><button @click="state.paused = !state.paused">{{ state.paused ? 'Resume' : 'Pause' }}</button><button @click="state.effects = !state.effects" :aria-pressed="state.effects">Effects {{ state.effects ? 'on' : 'off' }}</button><label>View <input type="range" min="0.7" max="1.5" step="0.05" v-model.number="state.zoom" aria-label="Zoom"></label><button @click="reset">Reset position</button></div><p>WASD / arrows · click ground to walk · E at portal · Space to pause</p></section>
 <div class="touchpad" aria-label="Movement controls"><button @pointerdown.prevent="move.y=-1" @pointerup="move.y=0" @pointerleave="move.y=0" aria-label="Move up">↑</button><div><button @pointerdown.prevent="move.x=-1" @pointerup="move.x=0" @pointerleave="move.x=0" aria-label="Move left">←</button><button @pointerdown.prevent="move.y=1" @pointerup="move.y=0" @pointerleave="move.y=0" aria-label="Move down">↓</button><button @pointerdown.prevent="move.x=1" @pointerup="move.x=0" @pointerleave="move.x=0" aria-label="Move right">→</button></div></div>
 <div v-if="state.paused" class="pause-label">TIME RESTS</div>
 <span class="prototype">Sanctuary exploration prototype</span>
</main>
</template>
