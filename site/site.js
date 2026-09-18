(() => {
  const form = document.querySelector("[data-search-form]");
  const input = document.querySelector("#site-search");
  const cards = [...document.querySelectorAll("[data-search-card]")];
  const empty = document.querySelector("[data-search-empty]");
  if (!form || !input) return;

  const indexPath = document.body.dataset.indexPath || "index.html";
  const onIndex = cards.length > 0;
  const params = new URLSearchParams(window.location.search);
  const initialQuery = params.get("q") || "";
  input.value = initialQuery;

  if (!onIndex) {
    form.addEventListener("submit", event => {
      event.preventDefault();
      const query = input.value.trim();
      window.location.href = `${indexPath}${query ? `?q=${encodeURIComponent(query)}` : ""}`;
    });
    return;
  }

  const filter = () => {
    const query = input.value.trim().toLowerCase();
    let visible = 0;
    cards.forEach(card => {
      const matches = !query || card.textContent.toLowerCase().includes(query);
      card.hidden = !matches;
      if (matches) visible += 1;
    });
    if (empty) empty.hidden = visible !== 0;
  };

  input.addEventListener("input", filter);
  form.addEventListener("submit", event => event.preventDefault());
  filter();
})();
