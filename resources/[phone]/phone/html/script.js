// Telefon JS
let phoneData = {};
let currentPage = 'menu';

window.addEventListener('message', function(event) {
    let item = event.data;
    if (!item || !item.type) return;

    if (item.type === "openPhone") {
        document.getElementById('phone-container').classList.remove('phone-hidden');
        currentPage = 'menu';
        showPage('menu');
        return;
    }

    if (item.type === 'updatePhone') {
        phoneData = phoneData || {};
        phoneData.phone = phoneData.phone || {};
        phoneData.phone.number = item.phoneNumber;
        phoneData.phone.bankAccount = item.bankAccount;
        phoneData.contacts = item.contacts || [];
        phoneData.messages = item.messages || [];
        updatePhoneUI();
        return;
    }

    if (item.type === 'updateContacts') {
        phoneData.contacts = item.contacts || [];
        if (currentPage === 'contacts') updateContacts();
        return;
    }

    if (item.type === 'updateMessages') {
        phoneData.messages = item.messages || [];
        if (currentPage === 'messages') updateMessages();
        return;
    }

    if (item.type === 'updateMoneyInfo') {
        phoneData.phone = phoneData.phone || {};
        phoneData.phone.balance = item.phoneBalance || (phoneData.phone.balance || 0);
        // Bank info display
        document.getElementById('bank-balance').innerText = '$' + (item.bank || 0);
        return;
    }

    if (item.type === 'updateFeed') {
        phoneData.feed = item.feed || [];
        if (currentPage === 'social') updateFeed();
        return;
    }

    if (item.type === 'updateMarket') {
        phoneData.market = item.listings || [];
        if (currentPage === 'market') updateMarket();
        return;
    }

    if (item.type === 'receiveLocation') {
        alert(`📍 Konum gönderildi: ${item.from} -> (${item.coords.x.toFixed(2)}, ${item.coords.y.toFixed(2)})`);
        return;
    }

    if (item.type === 'notification') {
        alert(item.message || 'Bildirim');
        return;
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
    if (page === 'social') { 
        // fetch latest feed from server
        fetch(`https://${GetParentResourceName()}/phoneAction`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ action: 'getFeed' })
        });
        updateFeed();
    }

    if (page === 'market') {
        fetch(`https://${GetParentResourceName()}/phoneAction`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ action: 'getListings' })
        });
        updateMarket();
    }
}

function createListing() {
    const title = document.getElementById('listing-title').value;
    const price = parseInt(document.getElementById('listing-price').value || '0');
    const desc = document.getElementById('listing-desc').value || '';
    if (!title || price <= 0) return alert('Başlık ve geçerli fiyat girin');

    fetch(`https://${GetParentResourceName()}/phoneAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'createListing', title: title, description: desc, price: price })
    });
    document.getElementById('listing-title').value = '';
    document.getElementById('listing-price').value = '';
    document.getElementById('listing-desc').value = '';
}

function updateMarket() {
    let html = '';
    const myNumber = phoneData.phone && phoneData.phone.number;
    if (phoneData.market && phoneData.market.length > 0) {
        phoneData.market.forEach(l => {
            html += `
                <div class="listing">
                    <div class="listing-title">${l.title} ${l.promoted ? '<span class="promoted">[Reklam]</span>' : ''}</div>
                    <div class="listing-desc">${l.description}</div>
                    <div class="listing-meta">Fiyat: $${l.price} | İlan: ${l.createdAt} | Sahibi: ${l.ownerNumber}</div>
                    <div class="listing-actions">
                        ${myNumber !== l.ownerNumber ? `<button onclick="buyListing(${l.id})">Satın Al</button>` : `<button onclick="removeListing(${l.id})">Kaldır</button> <button onclick="promoteListing(${l.id})">Reklam Ver ($50)</button>`}
                    </div>
                </div>
            `;
        });
    } else {
        html = '<p style="text-align:center;color:#999;">Henüz ilan yok</p>';
    }
    document.getElementById('listings').innerHTML = html;
}

function buyListing(id) {
    if (!confirm('Satın almak istediğinize emin misiniz?')) return;
    fetch(`https://${GetParentResourceName()}/phoneAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'buyListing', id: id })
    });
}

function removeListing(id) {
    if (!confirm('İlanı kaldırmak istediğinize emin misiniz?')) return;
    fetch(`https://${GetParentResourceName()}/phoneAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'removeListing', id: id })
    });
}

function promoteListing(id) {
    if (!confirm('İlanı tanıtmak için $50 banka ücreti alınacaktır. Onaylıyor musunuz?')) return;
    fetch(`https://${GetParentResourceName()}/phoneAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'promoteListing', id: id, fee: 50 })
    });
}

function postTweet() {
    const content = document.getElementById('tweet-text').value;
    if (!content) return;
    fetch(`https://${GetParentResourceName()}/phoneAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'postTweet', content: content })
    });
    document.getElementById('tweet-text').value = '';
}

function updateFeed() {
    let html = '';
    if (phoneData.feed && phoneData.feed.length > 0) {
        phoneData.feed.forEach(t => {
            html += `
                <div class="tweet">
                    <div class="tweet-from">${t.from}</div>
                    <div class="tweet-content">${t.content}</div>
                    <div class="tweet-time">${t.timestamp}</div>
                </div>
            `;
        });
    } else {
        html = '<p style="text-align:center;color:#999;">Henüz gönderi yok</p>';
    }
    document.getElementById('feed-list').innerHTML = html;
}

function shareLocation() {
    const number = document.getElementById('share-number').value;
    if (!number) return;
    fetch(`https://${GetParentResourceName()}/phoneAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'shareLocation', number: number })
    });
    document.getElementById('share-number').value = '';
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
    fetch(`https://${GetParentResourceName()}/phoneAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'checkBalance' })
    });
}

function updateCalls() {
    // Telefon geçmişi
}

function sendSMS() {
    const number = document.getElementById('sms-number').value;
    const message = document.getElementById('sms-text').value;
    
    if (number && message) {
        fetch(`https://${GetParentResourceName()}/phoneAction`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ action: 'sendSMS', number: number, message: message })
        });
        document.getElementById('sms-number').value = '';
        document.getElementById('sms-text').value = '';
    }
}

function callContact(number, name) {
    fetch(`https://${GetParentResourceName()}/phoneAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'call', number: number })
    });
}

function topupBalance() {
    const amount = prompt('Bakiye Yükle (TL):', '100');
    if (amount) {
        fetch(`https://${GetParentResourceName()}/phoneAction`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ action: 'addBalance', amount: parseInt(amount) })
        });
    }
}

function closePhone() {
    document.getElementById('phone-container').classList.add('phone-hidden');
    fetch(`https://${GetParentResourceName()}/phoneAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'close' })
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
