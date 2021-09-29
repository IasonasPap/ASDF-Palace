import {
  Tab,
  Tabs as MuiTabs,
} from '@material-ui/core';

const Tabs = ({ options, value, onChange }) => {
  return (
    <MuiTabs value={value} onChange={onChange}>
      {options.map((option, key) =>
        <Tab key={key} label={option} />)}
    </MuiTabs>
  );
};

export default Tabs;
