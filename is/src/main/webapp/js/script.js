/* =============================================
   JAVASCRIPT PARA EL SISTEMA DE GESTIÓN DE TAREAS
   ============================================= */

// Esperar a que el DOM esté listo
document.addEventListener('DOMContentLoaded', function() {
    console.log('Sistema de Gestión de Tareas - Inicializado');
    
    // Auto-cerrar alertas después de 5 segundos
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            alert.classList.add('fade');
            setTimeout(function() {
                alert.style.display = 'none';
            }, 500);
        }, 5000);
    });
    
    // Validación del formulario de login en tiempo real
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const submitBtn = document.getElementById('submitBtn');
    
    function validateForm() {
        if (emailInput && passwordInput && submitBtn) {
            const isValid = emailInput.value.trim() !== '' && passwordInput.value.trim() !== '';
            submitBtn.disabled = !isValid;
            submitBtn.style.opacity = isValid ? '1' : '0.5';
        }
    }
    
    if (emailInput && passwordInput) {
        emailInput.addEventListener('input', validateForm);
        passwordInput.addEventListener('input', validateForm);
        validateForm();
    }
    
    // Mostrar/ocultar contraseña (opcional)
    const togglePassword = document.getElementById('togglePassword');
    if (togglePassword && passwordInput) {
        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });
    }
});

// Función para mostrar mensajes de éxito
function showSuccessMessage(message) {
    alert(message); // Puedes reemplazar con una notificación más bonita
}

// Función para confirmar eliminación
function confirmDelete(message) {
    return confirm(message || '¿Estás seguro de eliminar este elemento?');
}