const Workbench = require('ethereum-sandbox-workbench')
const assert = require('assert')

const workbench = new Workbench({
  solcVersion: '0.4.2'
})
const defaultAccount = workbench.defaults.from

workbench.startTesting(['Prezzo', 'PrezzoManager'], (contracts) => {
  let prezzo
  let prezzoManager

  it('deploys prezzo', () => {
    return contracts.Prezzo.new()
      .then((contract) => {
        if (!contract.address) throw new Error('no address for contract')
        prezzo = contract
        return true
      })
  })

  it('deploy prezzo manager', () => {
    return contracts.PrezzoManager.new(prezzo.address)
      .then((contract) => {
        if (!contract.address) throw new Error('no address for contract')
        prezzoManager = contract
        return true
      })
  })

  it('allows manager to take prezzi', () => {
    return prezzo.approve(prezzoManager.address, 1000)
      .then((txHash) => workbench.waitForReceipt(txHash))
      .then(() => {
        assert.equal(prezzo.allowance(defaultAccount, prezzoManager.address), '1000')
        return true
      })
  })

  const code = '0x401020'
  it('registers ad', () => {
    const hash = workbench.sandbox.web3.sha3(code, { encoding: 'hex' })
    return prezzoManager.registerAd(defaultAccount, '0x' + hash, 1000)
      .then((txHash) => workbench.waitForReceipt(txHash))
      .then(() => {
        assert.equal(prezzo.balanceOf(prezzoManager.address), '1000')
        assert.equal(prezzo.balanceOf(defaultAccount), '9000')
        return true
      })
  })

  it('redeems code', () => {
    return prezzoManager.redeemPrezzi('0x101010')
      .then((txHash) => workbench.waitForReceipt(txHash))
      .then(() => {
        assert.equal(prezzo.balanceOf(prezzoManager.address), '1000')
        assert.equal(prezzo.balanceOf(defaultAccount), '9000')
        return prezzoManager.redeemPrezzi('0x401020')
      })
      .then((txHash) => workbench.waitForReceipt(txHash))
      .then(() => {
        assert.equal(prezzo.balanceOf(prezzoManager.address), '0')
        assert.equal(prezzo.balanceOf(defaultAccount), '10000')
        return true
      })
  })
})
