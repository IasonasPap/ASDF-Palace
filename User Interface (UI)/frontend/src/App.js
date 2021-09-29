import { useState } from "react";
import { Tabs } from './components';
import {
  Visits,
  Clients,
  Sales,
  Covid,
  Stats
} from "./routes";

const VISITS = 0;
const SALES = 1;
const CLIENTS = 2;
const COVID = 3;
const STATS = 4;

const App = () => {
  const [value, setValue] = useState(0);

  return (
    <div className="App">
      <Tabs
        options={['Visits and Services Use', 'Sales Per Service', "Clients' info", 'Covid-19 (Positive)', 'Stats Per Age Group']}
        value={value}
        onChange={(_, value) => setValue(value)}
      />
      {value === VISITS && <Visits />}
      {value === SALES && <Sales />}
      {value === CLIENTS && <Clients />}
      {value === COVID && <Covid />}
      {value === STATS && <Stats />}

    </div>
  );
};

export default App;
