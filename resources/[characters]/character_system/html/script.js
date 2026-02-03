window.addEventListener('message', function(event){
  const item = event.data;
  if(item.type === 'openChars'){
    const list = item.list || [];
    const container = document.getElementById('list');
    container.innerHTML = '';
    list.forEach((c, i) =>{
      const el = document.createElement('div');
      el.innerHTML = `<b>${c.name || ('Karakter '+(i+1))}</b> <button onclick="select(${i})">Seç</button>`;
      container.appendChild(el);
    });
  }
});

function createChar(){
  const data = {
    name: document.getElementById('name').value || ('Oyuncu'),
    face: parseInt(document.getElementById('face').value) || 1,
    hair: parseInt(document.getElementById('hair').value) || 1,
    weight: parseInt(document.getElementById('weight').value) || 70
  };
  fetch(`https://${GetParentResourceName()}/createCharacter`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
  });
}

function select(index){
  fetch(`https://${GetParentResourceName()}/selectCharacter`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({index: index})
  });
}

function previewChar(){
  const data = {
    name: document.getElementById('name').value || ('Oyuncu'),
    face: parseInt(document.getElementById('face').value) || 1,
    hair: parseInt(document.getElementById('hair').value) || 1,
    weight: parseInt(document.getElementById('weight').value) || 70
  };
  fetch(`https://${GetParentResourceName()}/previewCharacter`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
  });
}
