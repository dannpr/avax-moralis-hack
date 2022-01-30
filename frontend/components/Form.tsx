import { useWeb3React } from "@web3-react/core";
import { useMoralis } from "react-moralis";
import ABI from '../contracts/twitter-verifier.json'

function Form () {

    const { Moralis } = useMoralis();

    const { account } = useWeb3React();

    const callContractMethod = async (tweetId, username) => {

        const web3 = await (Moralis as any).enableWeb3()
        
        const contract = new web3.eth.Contract(ABI, '0x3C1Ab97CF4f2099A7e4926caA7011777d6b6961C')
        console.log(contract.methods)
        const requestValidation = await contract.methods.requestValidation(tweetId, username).call()
        console.log(requestValidation)
    }

    const submit = event => {
        event.preventDefault();

        const username = event.target.username.value
        const splitLink = event.target.twitterLink.value.split("/")
        const twitterId = splitLink[splitLink.length-1]
        callContractMethod(twitterId, username)
    }

    return(
        <div>
            <div className="pt-8">
                <a
                    className="px-8 py-2 bg-gray-500 text-white"
                    {...{
                        href:`https://twitter.com/intent/tweet?text=${account}`,//ne s'affiche pas quand j'enleve les coms
                        target: "_blank",
                        rel: "noopener noreferrer",
                    }}
                >
                    Tweet your address
                </a>
            </div>
            <div className="flex justify-center items-center">
                <form className='p-8' onSubmit={submit}>
                    <input className="rounded-sm p-2 m-2 border-2 w-full" type="text" name="username" placeholder="Username"/>        
                    <input className="rounded-sm p-2 m-2 border-2 w-full" type="text" name="twitterLink" placeholder="Twitter Link"/>
                    <button className="rounded-sm text-white m-2 p-2 bg-gray-500 w-full" type="submit">Verify</button>
                </form>
            </div>
        </div>
    );
}
export default Form
