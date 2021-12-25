function getElem(){
   console.log('test');
    var link = document.getElementById("username").textContent ;
    console.log(link);
    document.getElementById("j").innerHTML = link;
    
}
function Form () {

    var link = '';
    var username = '';

    const submit = event => {
        event.preventDefault();

        link = event.target.twitterLink.value
        username = event.target.username.value
        console.log( link + " "  + username)
        const splitLink = link.split("/")
        const twitterId = splitLink[splitLink.length-1]
    }

    return(
        <div id ="hj" className="post-input-container">
                
            <form style={{display: 'block'}} onSubmit={submit}>
                <input type="text" name="twitterLink" placeholder="Twitter Link"/>
                <input type="text" name="username" placeholder="Username"/>
                <button type="submit">Submit</button>
            </form>
            <span> 
                Username: {username}
            </span>
            <span> 
                Twitter Link: {link}
            </span>
        </div>
    );
}
export default Form
