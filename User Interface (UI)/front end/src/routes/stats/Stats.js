import {useState} from 'react';
import { Tabs } from '../../components';
import AgeGroup from './AgeGroup.js';

const YOUNG = 0;
const MIDDLE = 1;
const OLD = 2;

const Stats = () => {
  const [value, setValue] = useState(0);

  return (
    <div>
      <Tabs
        options={['20-40', '41-60', "61+"]}
        value={value}
        onChange={(_, value) => setValue(value)}
      />
      {value === YOUNG && <AgeGroup from={20} to={40}/>}
      {value === MIDDLE && <AgeGroup from={41} to={60}/>}
      {value === OLD && <AgeGroup from={61} to={150}/>}
      
    </div>
  );
};

export default Stats;
