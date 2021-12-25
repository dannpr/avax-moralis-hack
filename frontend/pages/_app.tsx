import { Web3ReactProvider } from "@web3-react/core";
import type { AppProps } from "next/app";
import getLibrary from "../getLibrary";
import "../styles/globals.css";
import '../styles/account.css';
import '../styles/form.css';
import { MoralisProvider } from "react-moralis";


function NextWeb3App({ Component, pageProps }: AppProps) {
  return (
    <MoralisProvider appId={process.env.MORALIS_APPLICATION_ID } serverUrl={process.env.MORALIS_SERVER_ID}>
    <Web3ReactProvider getLibrary={getLibrary}>
      <Component {...pageProps} />
    </Web3ReactProvider>
    </MoralisProvider>
  );
}

export default NextWeb3App;
