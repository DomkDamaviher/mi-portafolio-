function aplicarTema(tema) {
    document.documentElement.setAttribute('data-tema', tema);

    const boton = document.querySelector('#btn-tema');
    if (boton) {
        boton.textContent = tema === 'oscuro' ? '☀️' : '🌙';
        boton.setAttribute('aria-pressed', tema === 'oscuro');
        boton.setAttribute(
            'aria-label',
            tema === 'oscuro' ? 'Cambiar a tema claro' : 'Cambiar a tema oscuro'
        );
    }
}

function inicializarSelectorTema() {
    const boton = document.querySelector('#btn-tema');
    if (!boton) return;

    const temaActual = document.documentElement.getAttribute('data-tema') || 'claro';
    aplicarTema(temaActual);

    boton.addEventListener('click', () => {
        const temaVigente = document.documentElement.getAttribute('data-tema');
        const nuevoTema = temaVigente === 'oscuro' ? 'claro' : 'oscuro';
        aplicarTema(nuevoTema);
        localStorage.setItem('tema', nuevoTema);
    });
}

document.addEventListener('DOMContentLoaded', inicializarSelectorTema);
