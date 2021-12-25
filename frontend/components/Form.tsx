import { useWeb3React } from "@web3-react/core";

function Form () {

    const { account } = useWeb3React();

    const submit = event => {
        event.preventDefault();

        const username = event.target.username.value
        const splitLink = event.target.twitterLink.value.split("/")
        const twitterId = splitLink[splitLink.length-1]
        console.log(username + ' ' + twitterId)
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
