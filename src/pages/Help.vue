<template>
  <div class="container">
    <h2>
      How does the VeChain Name Service work?
    </h2>

    <p>
      Domains are auctioned through a process called a blind auction. An example of a Blind Auction is located. The advantage of a blind auction is that there is no time pressure towards the end of the bidding period. Creating a blind auction on a transparent computing platform might sound like a contradiction, but cryptography comes to the rescue.
    </p>

    <p>
      During the bidding period, a bidder does not actually send her bid, but only a hashed version of it. Since it is currently considered practically impossible to find two (sufficiently long) values whose hash values are equal, the bidder commits to the bid by that. After the end of the bidding period, the bidders have to reveal their bids: They send their values unencrypted and the contract checks that the hash value is the same as the one provided during the bidding period.
    </p>

    <p>
      Another challenge is how to make the auction binding and blind at the same time: The only way to prevent the bidder from just not sending the money after he won the auction is to make her send it together with the bid. Since value transfers cannot be blinded in VeChain, anyone can see the value.
    </p>

    <h3>Why send a good behavior bond?</h3>

    <p>To be continued...</p>
  </div>
</template>

<script>
export default {
  name: 'Help'
}
</script>

<style>

</style>
