import './main.css';
import { Main } from './Main.elm';
import moment from 'moment';

const app = Main.embed(document.getElementById('root'));

const getTime = () => {
  const strTime = moment().format('MMMM Do YYYY, h:mm:ss a');
  app.ports.responseMomentTime.send(strTime);
}

app.ports.requestMomentTime.subscribe(getTime);

