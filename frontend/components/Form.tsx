function getElem(){
   console.log('test');
    var link = document.getElementById("form").textContent ;
    console.log(link);
    document.getElementById("j").innerHTML = link;
    
}
const form =()=>
{
    return(<div id ="hj" className="post-input-container">
                    <textarea id="link"  placeholder= "enter a link"></textarea>
                    <div className="add-post-links">
                        
                    </div>
                
                <form>
                <input type="text" id="username" name="username" placeholder = "username"></input>
                </form>
                <button onClick={getElem}>Submit</button>
                <span id = "j"></span>
                </div>);}
export default form
