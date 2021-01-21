import './main.css'
import { Elm } from './Main.elm'
import * as serviceWorker from './serviceWorker'
import 'regenerator-runtime/runtime'
import * as Tone from 'tone'

const app = Elm.Main.init({
  node: document.getElementById('root')
})

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister()

const metronome = new Tone.Synth({
  oscillator: {
    type: 'sine',
    modulationFrequency: 0.2
  },
  envelope: {
    attack: 0,
    decay: 0.1,
    sustain: 0,
    release: 0.1
  }
}).toDestination()

const metronomePart = new Tone.Part(function (time, note) {
  metronome.triggerAttackRelease(note, 0.1, time)
}, [[0, 'C6'], ['0:1', 'C5'], ['0:2', 'C5'], ['0:3', 'C5'], ['0:4', 'C5'], ['0:5', 'C5'], ['0:6', 'C5']], '4n').start(0)

metronomePart.loop = true
metronomePart.loopEnd = '0:3'

app.ports.startMetronome.subscribe(function () {
  Tone.start().then((_) => {
    Tone.Transport.start()
  })
})

app.ports.stopMetronome.subscribe(function () {
  Tone.Transport.stop()
})

app.ports.setBpm.subscribe(function (bpm) {
  Tone.Transport.bpm.value = bpm
})

app.ports.setBeats.subscribe(function (beats) {
  metronomePart.loopEnd = `0:${beats}`
})
