import './main.css';
import { Main } from './Main.elm';
import moment from 'moment';

Main.embed(document.getElementById('root'));

const getTime = () => {
  const strTime = moment().format('MMMM Do YYYY, h:mm:ss a');
  return strTime;
}

