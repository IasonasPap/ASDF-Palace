import { useContext } from "react";
import { Context } from "../Provider";

const withContext = Component =>
  (props) => {
    const contextProps = useContext(Context);
    return <Component {...props} {...contextProps} />;
  };


export default withContext;
