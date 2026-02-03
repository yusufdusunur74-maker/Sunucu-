// Telefon JS
let phoneData = {};
let currentPage = 'menu';

window.addEventListener('message', function(event) {
    let item = event.data;
    
    if (item.type === "openPhone") {
        phoneData = item.data;
        updatePhoneUI();
        document.getElementById('phone-container').classList.remove('phone-hidden');
        currentPage = 'menu';
        showPage('menu');
    }
});

function showPage(page) {
    // Tüm sayfaları gizle
    document.querySelectorAll('.phone-content').forEach(el => {
        el.classList.add('hidden');
    });
    
    // İstenilen sayfayı göster
    document.getElementById(page + '-page').classList.remove('hidden');
    currentPage = page;
    
    if (page === 'contacts') updateContacts();
    if (page === 'messages') updateMessages();
    if (page === 'account') updateAccount();
    if (page === 'calls') updateCalls();
}

function updatePhoneUI() {
    if (phoneData && phoneData.phone) {
        document.getElementById('phone-number').textContent = phoneData.phone.number || '555-0000';
        document.getElementById('phone-balance').textContent = '$' + (phoneData.phone.balance || 0);
    }
}

function updateContacts() {
    let html = '';
    if (phoneData.contacts) {
        phoneData.contacts.forEach(contact => {
            html += `
                <div class="contact-item" onclick="callContact('${contact.number}', '${contact.name}')">
                    <div class="contact-name">${contact.name}</div>
                    <div class="contact-number">${contact.number}</div>
                </div>
            `;
        });
    }
    document.getElementById('contacts-list').innerHTML = html;
}

function updateMessages() {
    let html = '';
    if (phoneData.messages && phoneData.messages.length > 0) {
        phoneData.messages.forEach(msg => {
            html += `
                <div class="message-item">
                    <div class="message-from">From: ${msg.from}</div>
                    <div class="message-text">${msg.message}</div>
                    <div class="message-time">${msg.time || ''}</div>
                </div>
            `;
        });
    } else {
        html = '<p style="text-align: center; color: #999;">Henüz mesaj yok</p>';
    }
    document.getElementById('messages-list').innerHTML = html;
}

function updateAccount() {
    if (phoneData.phone) {
        document.getElementById('phone-number').textContent = phoneData.phone.number || '555-0000';
        document.getElementById('phone-balance').textContent = '$' + (phoneData.phone.balance || 0);
    }
    
    // Banka bakiyesini Al - Server'dan Get
    fetch(`https://${GetParentResourceName()}/phone:getMoneyInfo`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function updateCalls() {
    // Telefon geçmişi
}

function sendSMS() {
    const number = document.getElementById('sms-number').value;
    const message = document.getElementById('sms-text').value;
    
    if (number && message) {
        fetch(`https://${GetParentResourceName()}/phone:sendSMS`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                number: number,
                message: message
            })
        });
        
        document.getElementById('sms-number').value = '';
        document.getElementById('sms-text').value = '';
    }
}

function callContact(number, name) {
    console.log('Calling: ' + name + ' (' + number + ')');
}

function topupBalance() {
    const amount = prompt('Bakiye Yükle (TL):', '100');
    if (amount) {
        fetch(`https://${GetParentResourceName()}/phone:addBalance`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ amount: parseInt(amount) })
        });
    }
}

function closePhone() {
    document.getElementById('phone-container').classList.add('phone-hidden');
    fetch(`https://${GetParentResourceName()}/closePhone`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    });
}

// Saat Güncelle
function updateTime() {
    const now = new Date();
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    document.querySelector('.phone-time').textContent = hours + ':' + minutes;
}

setInterval(updateTime, 1000);
updateTime();
