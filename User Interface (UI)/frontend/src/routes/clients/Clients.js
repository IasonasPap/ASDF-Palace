import { useEffect, useState } from 'react';
import { Table } from '../../components';

const columns = [
  {
    field: 'first_name',
    headerName: 'First Name',
    width: 200,
  },
  {
    field: 'last_name',
    headerName: 'Last Name',
    width: 200,
  },
  {
    field: 'email',
    headerName: 'Email',
    width: 200,
  },
  {
    field: 'phone',
    headerName: 'Phone',
    width: 200,
  },
];


const Clients = () => {
  const [clients, setClients] = useState([]);

  useEffect(() => {
    fetch("http://localhost:5000/asdfpalace/clients")
      .then(response => response.json())
      .then(
        res => {
          let i=1;
          setClients(res.map(row =>{row.id = i++; return row}));}
    );
  }, []);
  
  return (
    <div>
      <Table
        rows={clients}
        columns={columns}
      />
    </div>
  );
};

export default Clients;
