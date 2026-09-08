const proyectos = [
    {
        titulo: 'Domk Store',
        descripcion: 'Prototipo de tienda de ropa online con catálogo, carrito de compras funcional (agregar, eliminar, total) y una API backend con Node.js y Express.',
        tecnologias: ['HTML5', 'CSS3', 'JavaScript', 'Node.js', 'Express'],
        enlace: 'https://github.com/DomkDamaviher/Pagina-de-ropa-Domk-Store',
        pendiente: false
    },
    {
        titulo: 'Mi Portafolio Web Interactivo',
        descripcion: 'Este mismo sitio: un portafolio personal construido con HTML5 semántico, CSS3 responsivo (Flexbox y Grid) y JavaScript vanilla, desplegado en GitHub Pages.',
        tecnologias: ['HTML5', 'CSS3', 'JavaScript'],
        enlace: '#',
        pendiente: false
    },
    {
        titulo: 'WANDA — Asistente de IA local',
        descripcion: 'Asistente de inteligencia artificial 100% offline con estética cyberpunk, construido en Python sobre Ollama. Incluye streaming de tokens en tiempo real, sesiones persistentes, un "Gaming Mode" con optimizaciones de Windows y un ícono en la bandeja del sistema.',
        tecnologias: ['Python', 'Ollama', 'pywebview', 'pystray'],
        enlace: 'https://github.com/DomkDamaviher/Wanda',
        pendiente: false
    }
];

function renderizarProyectos() {
    const contenedor = document.querySelector('#proyectos-grid');
    if (!contenedor) return;

    proyectos.forEach((proyecto) => {
        const articulo = document.createElement('article');

        articulo.className = proyecto.pendiente
            ? 'tarjeta-proyecto tarjeta-proyecto--pendiente'
            : 'tarjeta-proyecto';

        const tags = proyecto.tecnologias
            .map((tech) => `<span class="tag">${tech}</span>`)
            .join('');

        const enlaceHTML = proyecto.pendiente
            ? ''
            : `<a class="tarjeta-proyecto__enlace" href="${proyecto.enlace}" target="_blank" rel="noopener noreferrer">Ver proyecto</a>`;

        articulo.innerHTML = `
            <h3 class="tarjeta-proyecto__titulo">${proyecto.titulo}</h3>
            <p class="tarjeta-proyecto__descripcion">${proyecto.descripcion}</p>
            <div class="tarjeta-proyecto__tags">${tags}</div>
            ${enlaceHTML}
        `;

        contenedor.appendChild(articulo);
    });
}

function inicializarMenuMovil() {
    const botonHamburguesa = document.querySelector('.btn-hamburguesa');
    const navMovil = document.querySelector('.nav-movil');
    if (!botonHamburguesa || !navMovil) return;

    botonHamburguesa.addEventListener('click', () => {
        const abierto = navMovil.classList.toggle('activo');
        botonHamburguesa.setAttribute('aria-expanded', abierto);
    });

    navMovil.querySelectorAll('a').forEach((enlace) => {
        enlace.addEventListener('click', () => {
            navMovil.classList.remove('activo');
            botonHamburguesa.setAttribute('aria-expanded', 'false');
        });
    });
}

function actualizarAnio() {
    const spanAnio = document.querySelector('#anio-actual');
    if (spanAnio) spanAnio.textContent = new Date().getFullYear();
}

document.addEventListener('DOMContentLoaded', () => {
    renderizarProyectos();
    inicializarMenuMovil();
    actualizarAnio();
});
