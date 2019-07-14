module.exports = function(deployer) {
    deployer.deploy(artifacts.require("Distributor.sol"));
    deployer.deploy(artifacts.require("ReposioryFactory.sol"));
    // deployer.deploy(artifacts.require("Repository.sol"));
    deployer.deploy(artifacts.require("State.sol"));
    deployer.deploy(artifacts.require("UseState.sol"));
};
