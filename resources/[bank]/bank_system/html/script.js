function openDeposit() {
    document.getElementById('deposit-menu').style.display = 'block';
}

function closeModal() {
    document.querySelectorAll('.modal').forEach(m => m.style.display = 'none');
}

function confirmDeposit() {
    const amount = document.getElementById('deposit-amount').value;
    fetch(`https://${GetParentResourceName()}/bankAction`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({action: 'deposit', amount: parseInt(amount)})
    });
    closeModal();
}

window.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        closeModal();
        fetch(`https://${GetParentResourceName()}/bankAction`, {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({action: 'close'})
        });
    }
});
