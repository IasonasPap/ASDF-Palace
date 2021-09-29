import { useEffect, useState } from 'react';
import { Table } from '../../components';
import { TextField, Button } from "@material-ui/core";

const columns1 = [
  {
    field: 'title',
    headerName: 'Space',
    width: 200,
  },
  {
    field: 'location',
    headerName: 'Location',
    width: 200,
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

const columns2 = [
  {
    field: 'nfc_id',
    headerName: 'Client',
    width: 200,
  },
  {
    field: 'title',
    headerName: 'Location',
    width: 200,
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


const Covid = () => {
  const [nfc_id, setNfcId] = useState(0);
  const [visits, setVisits] = useState([]);
  const [infected, setInfected] = useState([]);


  const handleFindVisits = () => {
    fetch(`http://localhost:5000/asdfpalace/covid/${nfc_id}`)
    .then(response => response.json())
    .then(
      res => {
        let i=1;
        setVisits(res.map(row => {
          row.id = i++; 
          row.entry_time = row.entry_time.replace('T', ' ').replace('Z', '');
          row.exit_time = row.exit_time.replace('T', ' ').replace('Z', '');
          return row}));
        }
    );

    fetch(`http://localhost:5000/asdfpalace/infected/${nfc_id}`)
    .then(response => response.json())
    .then(
      res => {
        let i=1;
        setInfected(res.map(row => {
          row.id = i++; 
          row.entry_time = row.entry_time.replace('T', ' ').replace('Z', '');
          row.exit_time = row.exit_time.replace('T', ' ').replace('Z', '');
          return row}));
        }
    );
  }

  return (
    <div>
      <TextField
          style={{ maxWidth: '16ch' }}
          type="number"
          label="Client's nfc_if"
          size="small"
          variant="outlined"
          value={nfc_id}
          onChange={(event) => setNfcId(event.target.value)}
        />
        <Button
        color="primary"
        variant="contained"
        size="small"
        onClick={handleFindVisits}
      >
        Search
      </Button>

      <Table
        rows={visits}
        columns={columns1}
      />
      <Table
        rows={infected}
        columns={columns2}
      />
    </div>
  );
};

export default Covid;
