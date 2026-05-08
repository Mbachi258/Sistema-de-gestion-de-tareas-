document.addEventListener("DOMContentLoaded", function () {
    const toggles = document.querySelectorAll("[data-toggle-password]");

    toggles.forEach(function (button) {
        button.addEventListener("click", function () {
            const field = button.parentElement.querySelector("input");
            if (!field) {
                return;
            }
            const visible = field.getAttribute("type") === "text";
            field.setAttribute("type", visible ? "password" : "text");
            button.textContent = visible ? "Ver" : "Ocultar";
        });
    });
});
