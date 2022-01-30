import { Web3ReactProvider } from "@web3-react/core";
import type { AppProps } from "next/app";
import getLibrary from "../getLibrary";
import "../styles/globals.css";
import '../styles/account.css';
import '../styles/form.css';
import { MoralisProvider } from "react-moralis";


function NextWeb3App({ Component, pageProps }: AppProps) {
  const apikey='Y2LtZ2IgOkjtBxlHK6HP7PxPqoaAmaxLzxsSsDD2';
  const url = 'https://aen838gbrwsp.usemoralis.com:2053/server';
  return (
    <MoralisProvider appId={apikey} serverUrl={url}>
    <Web3ReactProvider getLibrary={getLibrary}>
      <Component {...pageProps} />
    </Web3ReactProvider>
    </MoralisProvider>
  );
}

export default NextWeb3App;
