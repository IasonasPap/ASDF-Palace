import { useEffect, useState } from 'react';
import { Filters, Table } from '../../components';


const columns = [
  {
    field: 'nfc_id',
    headerName: 'Client',
    width: 150,
  },
  {
    field: 'title',
    headerName: 'Space',
    width: 150,
  },
  {
    field: 'entry_time',
    headerName: 'Entry time',
    width: 200,
  },
  {
    field: 'exit_time',
    headerName: 'Exit time',
    width: 200,
  }
];


const Visits = () => {
  const [visits, setVisits] = useState([]);

  const handleSearchVisits = (visits) => setVisits(visits);

  return (
    <div>
      <Filters handleSearchVisits={handleSearchVisits}/>
      <h1>VISITS BASED ON FILTERS</h1>
      <Table
        rows={visits}
        columns={columns}
      />
    </div>
  );
};

export default Visits;
