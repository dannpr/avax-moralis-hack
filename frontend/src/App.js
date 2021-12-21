import logo from './logo.svg';
import './App.css';
import { Component } from 'react';
import getWeb3 from './Components/ConnectWeb3';

class App extends Component {

  constructor() {
    super()
    this.state = {
      web3: getWeb3(),
      account: '',
    }
    this.setAccount = this.setAccount.bind(this)
  }

  async setAccount() {
    const accounts = await window.ethereum.request({method: "eth_requestAccounts"})
    this.setState({account: accounts[0]}, () => {
      console.log(this.state.account)
    })
  }

  async componentDidMount() {
  }

  render() {
    return (
      <div className="App">
        <div className='pt-72 text-2xl font-inter'>
          {this.state.account !== '' ?
            <div className='flex justify-center items-center'>
              <a className="twitter-share-button bg-blue-400 p-4 rounded-md" href={`https://twitter.com/intent/tweet?text=${("Verifying my ETH address: " + this.state.account).replace(' ', '%20')}`}>
                Verify your address: {this.state.account.substring(0, 4) + '...' + this.state.account.substring(this.state.account.length-4, this.state.account.length)}
              </a>
            </div>
            :
            <div>
              <button className='focus:none p-4 bg-blue-400 rounded-md' onClick={this.setAccount}>
                <img className='inline' src='metamask.svg'/> MetaMask 
              </button>
            </div>
          }
        </div>
      </div>
    );
  }
}

export default App;
