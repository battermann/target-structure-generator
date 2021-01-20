import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';
import 'regenerator-runtime/runtime'
import * as Tone from 'tone'

const app = Elm.Main.init({
  node: document.getElementById('root')
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();

app.ports.startMetronome.subscribe(function () {
  console.log("start")
  Tone.Transport.start()
})

app.ports.stopMetronome.subscribe(function () {
  console.log("stop")
  Tone.Transport.stop()
})

app.ports.setBpm.subscribe(function (bpm) {
  console.log("set bpm", bpm)
  Tone.Transport.bpm.value = bpm
  console.log(Tone.Transport.bpm.value)
})

app.ports.setBeats.subscribe(function (metryx) {
  console.log("set metryx", metryx)
})

