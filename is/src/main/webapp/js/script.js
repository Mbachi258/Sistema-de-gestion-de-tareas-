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

    document.querySelectorAll("[data-toggle-detail]").forEach(function (button) {
        button.addEventListener("click", function () {
            const card = button.closest(".group-card");
            const detail = card ? card.querySelector(".team-detail") : null;
            if (!detail) {
                return;
            }
            const hidden = detail.hasAttribute("hidden");
            if (hidden) {
                detail.removeAttribute("hidden");
                button.textContent = "Ocultar detalle";
            } else {
                detail.setAttribute("hidden", "");
                button.textContent = "Ver detalle";
            }
        });
    });

    document.querySelectorAll("[data-progress-range]").forEach(function (range) {
        const card = range.closest("[data-task-card]");
        const label = card ? card.querySelector("[data-progress-label]") : null;
        range.addEventListener("input", function () {
            if (label) {
                label.textContent = range.value + "%";
            }
        });
    });

    document.querySelectorAll(".ajax-progress-form").forEach(function (form) {
        form.addEventListener("submit", function (event) {
            event.preventDefault();
            const button = form.querySelector("button[type='submit']");
            const status = form.querySelector("[data-form-status]");
            const card = form.closest("[data-task-card]");
            const stateLabel = card ? card.querySelector("[data-state-label]") : null;
            const range = form.querySelector("[data-progress-range]");
            const data = new FormData(form);
            data.set("ajax", "1");

            if (button) {
                button.disabled = true;
                button.textContent = "Guardando";
            }
            if (status) {
                status.textContent = "";
            }

            fetch(form.action, {
                method: "POST",
                body: data,
                headers: {
                    "X-Requested-With": "XMLHttpRequest",
                    "Accept": "application/json"
                }
            })
                .then(function (response) {
                    return response.text().then(function (text) {
                        try {
                            return JSON.parse(text);
                        } catch (error) {
                            throw new Error("No pudimos guardar. Recarga la pagina e intenta otra vez.");
                        }
                    });
                })
                .then(function (payload) {
                    if (!payload.ok) {
                        throw new Error(payload.mensaje || "No se pudo guardar.");
                    }
                    if (status) {
                        status.textContent = payload.mensaje;
                    }
                    if (stateLabel && range) {
                        const value = Number(range.value);
                        stateLabel.textContent = value === 0 ? "Pendiente" : (value === 100 ? "Completada" : "En progreso");
                    }
                    form.querySelector("input[name='comentario']").value = "";
                })
                .catch(function (error) {
                    if (status) {
                        status.textContent = error.message;
                    }
                })
                .finally(function () {
                    if (button) {
                        button.disabled = false;
                        button.textContent = "Guardar avance";
                    }
                });
        });
    });
});
