import ERC20_ABI from "../contracts/ERC20.json";
import useContract from "./useContract";

export default function useTokenContract(tokenAddress?: string) {
  return useContract(tokenAddress, ERC20_ABI);
}
