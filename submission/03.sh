# Create a raw transaction and add this message in it: "btrust builder 2025"

# Amount of 20,000,000 satoshis to this address: 2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP 
# Use the UTXOs from the transaction below
# transaction="01000000000101c8b0928edebbec5e698d5f86d0474595d9f6a5b2e4e3772cd9d1005f23bdef772500000000ffffffff0276b4fa0000000000160014f848fe5267491a8a5d32423de4b0a24d1065c6030e9c6e000000000016001434d14a23d2ba08d3e3edee9172f0c97f046266fb0247304402205fee57960883f6d69acf283192785f1147a3e11b97cf01a210cf7e9916500c040220483de1c51af5027440565caead6c1064bac92cb477b536e060f004c733c45128012102d12b6b907c5a1ef025d0924a29e354f6d7b1b11b5a7ddff94710d6f0042f3da800000000"


UTXO_RAW_TX="01000000000101c8b0928edebbec5e698d5f86d0474595d9f6a5b2e4e3772cd9d1005f23bdef772500000000ffffffff0276b4fa0000000000160014f848fe5267491a8a5d32423de4b0a24d1065c6030e9c6e000000000016001434d14a23d2ba08d3e3edee9172f0c97f046266fb0247304402205fee57960883f6d69acf283192785f1147a3e11b97cf01a210cf7e9916500c040220483de1c51af5027440565caead6c1064bac92cb477b536e060f004c733c45128012102d12b6b907c5a1ef025d0924a29e354f6d7b1b11b5a7ddff94710d6f0042f3da800000000"
PAYMENT_ADDRESS="2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP"
AMOUNT=20000000
AMOUNT_BTC=$(printf "%.8f" "$(bc -l <<< "scale=8; $AMOUNT / 100000000")")
MESSAGE="btrust builder 2025"

decode_tx=$(bitcoin-cli -regtest decoderawtransaction $UTXO_RAW_TX)
#echo $decode_tx | jq '.'

# Here we that an single utxo cannot be use as per value is less than 0.2 btc
UTXO_TXID=$(echo $decode_tx | jq -r '.txid')
#echo $UTXO_TXID

UTXO_VOUT_INDEX_1=$(echo "$decode_tx" | jq -r '.vout[0].n')
UTXO_VOUT_INDEX_2=$(echo "$decode_tx" | jq -r '.vout[1].n')
#echo $UTXO_VOUT_INDEX_1 $UTXO_VOUT_INDEX_2

#op_return_data=$(echo -n "$MESSAGE" | sha256sum | awk '{print $1}')
#echo $op_return_data

op_return_data=$(echo -n "$MESSAGE" | xxd -p | tr -d '\n')
#echo $op_return_data

TX_INPUTS="[{\"txid\": \"$UTXO_TXID\", \"vout\": $UTXO_VOUT_INDEX_1}, {\"txid\": \"$UTXO_TXID\", \"vout\": $UTXO_VOUT_INDEX_2}]"

TX_OUTPUTS="[{\"data\":\"$op_return_data\"}, {\"$PAYMENT_ADDRESS\": $AMOUNT_BTC}]"

RAW_TX=$(bitcoin-cli -regtest createrawtransaction "$TX_INPUTS" "$TX_OUTPUTS")
echo $RAW_TX
