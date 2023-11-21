// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLoteria {
    address public owner;
    address[] public jugadores;
    uint256 public costoEntrada;
    uint256 public premioAcumulado;
    uint256 public numeroGanador;

    event NuevoJugador(address jugador, uint256 cantidadApostada);
    event GanadorElegido(address ganador, uint256 premio);

    constructor(uint256 _costoEntrada) {
        owner = msg.sender;
        costoEntrada = _costoEntrada;
    }

    modifier soloPropietario() {
        require(msg.sender == owner, "Solo el propietario puede llamar a esta función");
        _;
    }

    function participar() external payable {
        require(msg.value == costoEntrada, "La cantidad de apuesta no coincide con el costo de entrada");

        jugadores.push(msg.sender);
        premioAcumulado += msg.value;

        emit NuevoJugador(msg.sender, msg.value);

        if (jugadores.length >= 5) {
            elegirGanador();
        }
    }

    function elegirGanador() internal soloPropietario {
        require(jugadores.length >= 5, "Se necesitan al menos 5 jugadores para elegir un ganador");

        // Se elige un número aleatorio sencillo para simular el ganador
        numeroGanador = block.timestamp % jugadores.length;
        address ganador = jugadores[numeroGanador];

        // Transfiere el premio al ganador
        payable(ganador).transfer(premioAcumulado);

        emit GanadorElegido(ganador, premioAcumulado);

        // Reinicia el juego
        reiniciarJuego();
    }

    function reiniciarJuego() internal {
        delete jugadores;
        premioAcumulado = 0;
        numeroGanador = 0;
    }

    function obtenerNumeroParticipantes() external view returns (uint256) {
        return jugadores.length;
    }

    function obtenerPremioAcumulado() external view returns (uint256) {
        return premioAcumulado;
    }
}
