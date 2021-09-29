import { DataGrid } from '@material-ui/data-grid';

export default function DataTable({ rows, columns }) {
  console.log(rows);
  return (
    <div style={{ height: 500, width: '80%' }}>
      <DataGrid
        rows={rows}
        columns={columns}
      />
    </div>
  );
}