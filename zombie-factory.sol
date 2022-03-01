// SPDX-License-Identifier: UNLICENSED

// O primeiro comentário se refere à licença do contrato inteligente abaixo ser open-source ou não
// Como foi colocado unlicensed, significa que o código abaixo não é open-source
// Se eu quisesse que fosse open-souce, poderia substituir o UNLICENSED por MIT

pragma solidity ^0.8.12;

// todoo arquivo solidity deve ser iniciado com a palavra chave pragma e a versão solidity em questão


// Os contratos inteligentes são escritos dentro de classes contracts
contract ZombieFactory {

    // um evento é uma forma de declarar ao front-end que algo relevante aconteceu no backend
    event NewZombie(uint zombieId, string name, uint dna);

    // unsigned int são inteiros sem sinal
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    // structs em solidity são parecidas com structs em c, a parte de como são declaradas, dado que em solidity possuem um cons
    //trutor inerente nelas que segue a ordem dos atributos
    struct Zombie {
        string name;
        uint dna;
    }

    // variaveis e funções públicas podem ser acessadas por qualquer usuário da blockchain
    Zombie[] public zombies;


    // maps em solidity são chamados mapping, que, ao invés de declararem o nome da chave-valor, declaram apenas o tipo das variáveis
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    // variaveis e funções privadas só podem ser acessadas e rodadas pelo contrato que a declara
    function _createZombie(string memory _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
        uint id = zombies.length - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;

        // emissao do evento de registro de um novo zumbi
        emit NewZombie(id, _name, _dna);
    }

    // funções view utilizam de variaveis/informações que estão fora do escopo da função
    // funções pure só utilizam o que está em seu escopo
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        // o require é uma função que funciona como condicional para a realzação do resto da função
        // caso queiramos que uma string seja igual a outra, devemos fazer:
        // keccak256(abi.encodePacked(string))==keccak256(abi.encodePacked("string"));
        // dado que não existe como comparar strings diretamente em solidity
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
