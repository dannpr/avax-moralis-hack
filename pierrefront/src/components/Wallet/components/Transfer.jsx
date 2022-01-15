import { CreditCardOutlined } from "@ant-design/icons";
import { Button, Input, notification } from "antd";
import Text from "antd/lib/typography/Text";
import { useEffect, useState } from "react";
import { useMoralis } from "react-moralis";
import AddressInput from "../../AddressInput";
localStorage.setItem('tnsIdentif', '');
var tnsIdentif = "";
const styles = {
  card: {
    alignItems: "center",
    width: "100%",
  },
  header: {
    textAlign: "center",
  },
  input: {
    width: "100%",
    outline: "none",
    fontSize: "16px",
    whiteSpace: "nowrap",
    overflow: "hidden",
    textverflow: "ellipsis",
    appearance: "textfield",
    color: "#041836",
    fontWeight: "700",
    border: "none",
    backgroundColor: "transparent",
  },
  select: {
    marginTop: "20px",
    display: "flex",
    alignItems: "center",
  },
  textWrapper: { maxWidth: "80px", width: "100%" },
  row: {
    display: "flex",
    alignItems: "center",
    gap: "10px",
    flexDirection: "row",
  },
};

function Transfer() {
  const { Moralis } = useMoralis();
  const [link, setLink] = useState();
  
  const [tx, setTx] = useState();
  const [user, setUser] = useState();
  const [isPending, setIsPending] = useState(false);

  useEffect(() => {
    user && link ? setTx({ amount: user, receiver: link }) : setTx();
  }, [ user, link]);

  

  async function callTwitter() {
    // const contract = new web3.eth.Contract(ABI, '0x3C1Ab97CF4f2099A7e4926caA7011777d6b6961C')
    // console.log(contract.methods)
    // const requestValidation = await contract.methods.requestValidation(tweetId, username).call()
    // console.log(requestValidation)
    tnsIdentif =  user; 
    console.log(tnsIdentif);
  }

  return (
    <div style={styles.card}>
      <div style={styles.tranfer}>
        <div style={styles.header}>
          <h3>Transfer Assets</h3>
        </div>
        <div style={styles.select}>
          <div style={styles.textWrapper}>
            <Text strong>Link :</Text>
          </div>
          <AddressInput autoFocus onChange={setLink} />
        </div>
        <div style={styles.select}>
          <div style={styles.textWrapper}>
            <Text strong>User:</Text>
          </div>
          <Input
            size="large"
            
            onChange={(e) => {
              setUser(`${e.target.value}`);
            }}
          />
        </div>
        
        <Button
          type="primary"
          size="large"
          loading={isPending}
          style={{ width: "100%", marginTop: "25px" }}
          onClick={() => callTwitter()}
        >
         Connect twitter
        </Button>
      </div>
    </div>
  );
}
localStorage.setItem('tnsIdentif', tnsIdentif);

export default Transfer;
export{tnsIdentif};

