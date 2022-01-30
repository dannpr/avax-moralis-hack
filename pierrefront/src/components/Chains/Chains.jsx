import { useEffect, useState } from "react";
import { Menu, Dropdown, Button } from "antd";
import { DownOutlined } from "@ant-design/icons";
import { AvaxLogo, PolygonLogo, BSCLogo, ETHLogo } from "./Logos";
import { useChain, useMoralis } from "react-moralis";

const styles = {
  item: {
    display: "flex",
    alignItems: "center",
    height: "42px",
    fontWeight: "500",
    fontFamily: "Roboto, sans-serif",
    fontSize: "14px",
    padding: "0 10px",
  },
  button: {
    border: "2px solid rgb(231, 234, 243)",
    borderRadius: "12px",
  },
};


const fuji ={
  key: "0xa869",
  value: "Avalanche Testnet",
  icon: <AvaxLogo />,
}

function Chains() {
  const { switchNetwork, chainId, chain } = useChain();
  const { isAuthenticated } = useMoralis();

  console.log("chain", chain);

  const handleMenuClick = () => {
    console.log("switch to: ", "0xa869");
    switchNetwork("0xa869");
  };

  
  var state = chainId==fuji.key?fuji:{
    key: "0xa869",
    value: "Switch to Avalanche Testnet",
    icon: <AvaxLogo />,
  }

  if (!chainId || !isAuthenticated) return null;

  

  return (
    <div>
      
        <Button id="button" onClick={handleMenuClick} key={state.key} icon={state.icon} style={{ ...styles.button, ...styles.item }}>
          <span style={{ marginLeft: "5px" }}>{state.value}</span>
          
        </Button>
      
    </div>
  );
}

export default Chains;
