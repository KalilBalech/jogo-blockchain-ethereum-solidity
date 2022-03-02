// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.12;

import "./zombie-factory.sol"; // importação do outro aquivo

/*
Em solidity, na maioria das vezes, não é necessário declarar como uma variável ou função deve ser armazenada na memória. Isso
ocorre, pois o compilador costuma fazer isso automaticamente para nós. No entanto, existem algumas situações, que envolvem
structs ou arrays, em que devemos explicitar como queremos armazenar as variáveis na memória.
Existem duas formas de armazenamento: storage e memory.
Storage:
São guardadas permanentemente na blockchain (~disco rígido-hd)
Variáveis declaradas fora de funções são por padrão storage e são guardadas permanentemente na blockchain
arrays e structs storage dentro de funções são, na verdade, ponteiros para o array/struct real, em que, se alterados, 
alteram a versão original da estrutura de dados

Memory:
São guardadas temporariamente na memória e são apagadas logo que desnecessárias (~memória ram)
Variáveis dentro das funções são por padrão memory e desaparecem quando a função termina
Variáveis struct/array memory dentro de funções são cópias das versões originais e, se alteradas, não alteram a estrutura original

*/

/*

Em solidity, porém, existe outro tipo de visibilidade de funções diferente de privayte e public. Elas são internal e external.

Funções internal são funções iguais a private só que podem também ser chamadas por contratos herdeiros - menos restritivo

Funções external são funções iguais a public só que só podem ser chamadas em funções que estão fora de contratos + mais restritivo

*/

contract ZombieFeeding is ZombieFactory {

    function feedAndMultiply(uint256 _zombieId, uint256 _targetDna) public {

        require(msg.sender == zombieToOwner[_zombieId]);

        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + _targetDna) / 2;
        _createZombie("NoName", newDna); // por conta dessa chamada, tivemos que alterar o tipo da função _createZombie de private
                                        // para internal
    }
}
