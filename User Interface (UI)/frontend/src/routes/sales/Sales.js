import { useEffect, useState } from 'react';
import { Table } from '../../components';

const columns = [
  {
    field: 'title',
    headerName: 'Service',
    width: 200,
  },
  {
    field: 'number of sales',
    headerName: 'Number Of Sales',
    width: 200,
  },
];


const Sales = () => {
  const [sales, setSales] = useState([]);

  useEffect(() => {
    fetch("http://localhost:5000/asdfpalace/sales")
    .then(response => response.json())
    .then(
      res => {
        let i=1;
        setSales(res.map(row =>{row.id = i++; return row}));}
    );
  }, []);

  return (
    <div>
      <Table
        rows={sales}
        columns={columns}
      />
    </div>
  );
};

export default Sales;
