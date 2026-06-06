(function () {
  "use strict";

  var doc = document;
  var win = window;
  var toastStack;

  function ready(fn) {
    if (doc.readyState === "loading") {
      doc.addEventListener("DOMContentLoaded", fn);
      return;
    }
    fn();
  }

  function createToastStack() {
    toastStack = doc.querySelector(".app-toast-stack");
    if (toastStack) return toastStack;

    toastStack = doc.createElement("div");
    toastStack.className = "app-toast-stack";
    toastStack.setAttribute("aria-live", "polite");
    toastStack.setAttribute("aria-atomic", "true");
    doc.body.appendChild(toastStack);
    return toastStack;
  }

  function showToast(message, type) {
    var stack = createToastStack();
    var toast = doc.createElement("div");
    toast.className = "app-toast is-" + (type || "info");
    toast.textContent = message;
    stack.appendChild(toast);
    win.setTimeout(function () {
      toast.style.opacity = "0";
      toast.style.transform = "translateY(8px)";
      win.setTimeout(function () {
        toast.remove();
      }, 220);
    }, 2800);
  }

  function getPreferredMode() {
    try {
      return localStorage.getItem("app-theme-mode") || "light";
    } catch (error) {
      return "light";
    }
  }

  function resolveMode(mode) {
    if (mode === "light" || mode === "dark") return mode;
    if (win.matchMedia && win.matchMedia("(prefers-color-scheme: dark)").matches) return "dark";
    return "light";
  }

  function applyThemeMode(mode, silent) {
    var storedMode = mode || getPreferredMode();
    var resolvedMode = resolveMode(storedMode);

    doc.documentElement.setAttribute("data-bs-theme", resolvedMode);
    doc.documentElement.style.colorScheme = resolvedMode;

    var metaTheme = doc.querySelector('meta[name="theme-color"]');
    if (metaTheme) {
      metaTheme.setAttribute("content", resolvedMode === "dark" ? "#0f172a" : "#f97316");
    }

    try {
      localStorage.setItem("app-theme-mode", storedMode);
    } catch (error) {}

    doc.querySelectorAll("[data-theme-mode]").forEach(function (button) {
      button.classList.toggle("is-active", button.getAttribute("data-theme-mode") === storedMode);
      button.setAttribute("aria-pressed", button.classList.contains("is-active") ? "true" : "false");
    });

    doc.querySelectorAll("[data-theme-mode-cycle]").forEach(function (button) {
      var icon = button.querySelector("i");
      button.dataset.currentMode = resolvedMode;
      button.setAttribute("aria-label", resolvedMode === "dark" ? "تغییر به حالت روشن" : "تغییر به حالت تاریک");
      if (icon) {
        icon.className = resolvedMode === "dark" ? "fas fa-sun" : "fas fa-moon";
        icon.setAttribute("aria-hidden", "true");
      }
    });

    if (!silent) {
      showToast(resolvedMode === "dark" ? "حالت تاریک فعال شد." : "حالت روشن فعال شد.", "success");
    }
  }

  function initThemeMode() {
    applyThemeMode(getPreferredMode(), true);

    doc.addEventListener("click", function (event) {
      var explicitButton = event.target.closest("[data-theme-mode]");
      if (explicitButton) {
        applyThemeMode(explicitButton.getAttribute("data-theme-mode"));
        return;
      }

      var cycleButton = event.target.closest("[data-theme-mode-cycle]");
      if (cycleButton) {
        var current = resolveMode(getPreferredMode());
        applyThemeMode(current === "dark" ? "light" : "dark");
      }
    });

    if (win.matchMedia) {
      var media = win.matchMedia("(prefers-color-scheme: dark)");
      var onSystemChange = function () {
        if (getPreferredMode() === "system") {
          applyThemeMode("system", true);
        }
      };
      if (media.addEventListener) media.addEventListener("change", onSystemChange);
      else if (media.addListener) media.addListener(onSystemChange);
    }
  }

  function initTemplateRefactor() {
    doc.body.classList.add("app-template-refactored");

    var content = doc.getElementById("content-limit");
    if (content) {
      Array.prototype.forEach.call(content.children, function (child) {
        child.classList.add("app-screen-section");
      });

      var heading = content.querySelector("h1, h2");
      if (heading) heading.classList.add("app-page-heading");
    }

    doc.querySelectorAll("form").forEach(function (form) {
      form.classList.add("app-form-enhanced");
      var submitRow = form.querySelector(".submit-row, .form-actions, .um-modal-footer");
      if (submitRow) submitRow.classList.add("app-sticky-actions");
    });

    doc.querySelectorAll(".modal").forEach(function (modal) {
      modal.classList.add("app-bottom-sheet-ready");
    });
  }

  function initCardTables() {
    doc.querySelectorAll("table").forEach(function (table) {
      prepareTable(table);
    });
  }

  function prepareTable(table) {
      var headers = Array.prototype.map.call(table.querySelectorAll("thead th"), function (th) {
        return th.textContent.trim();
      });

      if (!headers.length) return;

      table.classList.add("app-card-table-ready");
      table.querySelectorAll("tbody tr").forEach(function (row) {
        row.querySelectorAll("td").forEach(function (cell, index) {
          if (!cell.dataset.label) {
            cell.dataset.label = headers[index] || "";
          }
        });
      });
  }

  function observeTableChanges() {
    if (!("MutationObserver" in win)) return;
    doc.querySelectorAll("tbody").forEach(function (tbody) {
      var table = tbody.closest("table");
      if (!table || tbody.dataset.appObserved) return;
      tbody.dataset.appObserved = "true";
      new MutationObserver(function () {
        prepareTable(table);
        initEmptyStates();
      }).observe(tbody, { childList: true, subtree: true });
    });
  }

  function initEmptyStates() {
    doc.querySelectorAll("tbody").forEach(function (tbody) {
      var table = tbody.closest("table");
      if (!table || tbody.children.length) return;

      var wrapper = table.closest(".table-responsive, .responsive-table, .table-wrapper, .um-table-wrapper") || table.parentElement;
      if (!wrapper || wrapper.querySelector(".app-empty-state")) return;

      var empty = doc.createElement("div");
      empty.className = "app-empty-state";
      empty.innerHTML = '<i class="fas fa-inbox" aria-hidden="true"></i><strong>موردی برای نمایش وجود ندارد</strong><span>با تغییر فیلتر یا ثبت مورد جدید، اطلاعات این بخش نمایش داده می‌شود.</span>';
      wrapper.appendChild(empty);
    });
  }

  function getFieldMessage(field) {
    if (field.validity.valueMissing) return "این فیلد ضروری است.";
    if (field.validity.typeMismatch) return "فرمت وارد شده درست نیست.";
    if (field.validity.patternMismatch) return "مقدار وارد شده با الگوی مورد انتظار هماهنگ نیست.";
    if (field.validity.tooShort) return "مقدار وارد شده کوتاه است.";
    if (field.validity.tooLong) return "مقدار وارد شده طولانی است.";
    if (field.validity.rangeUnderflow || field.validity.rangeOverflow) return "مقدار انتخاب شده در بازه مجاز نیست.";
    return "";
  }

  function setFieldState(field) {
    if (!field.matches("input, select, textarea")) return;
    if (field.type === "hidden" || field.disabled || field.readOnly) return;

    var invalid = field.required || field.value ? !field.checkValidity() : false;
    var hintId = field.id ? field.id + "-app-hint" : "";
    var hint = hintId ? doc.getElementById(hintId) : null;

    field.classList.toggle("is-invalid", invalid);
    field.classList.toggle("is-valid", !invalid && Boolean(field.value) && field.checkValidity());
    field.setAttribute("aria-invalid", invalid ? "true" : "false");

    if (invalid) {
      if (!hint && hintId) {
        hint = doc.createElement("small");
        hint.id = hintId;
        hint.className = "app-field-hint";
        field.insertAdjacentElement("afterend", hint);
        field.setAttribute("aria-describedby", [field.getAttribute("aria-describedby"), hintId].filter(Boolean).join(" "));
      }
      if (hint) hint.textContent = getFieldMessage(field);
    } else if (hint) {
      hint.textContent = "";
    }
  }

  function initSmartValidation() {
    doc.addEventListener("input", function (event) {
      var field = event.target;
      if (!field.matches("input, select, textarea")) return;
      field.classList.add("was-touched");
      setFieldState(field);
    });

    doc.addEventListener("blur", function (event) {
      var field = event.target;
      if (!field.matches("input, select, textarea")) return;
      field.classList.add("was-touched");
      setFieldState(field);
    }, true);

    doc.addEventListener("submit", function (event) {
      var form = event.target;
      if (!form.matches("form")) return;

      form.querySelectorAll("input, select, textarea").forEach(function (field) {
        field.classList.add("was-touched");
        setFieldState(field);
      });

      if (!form.checkValidity()) {
        showToast("لطفا فیلدهای مشخص شده را بررسی کنید.", "warning");
        return;
      }

      var submitter = event.submitter || form.querySelector('[type="submit"]');
      if (submitter && !submitter.dataset.originalText) {
        submitter.dataset.originalText = submitter.innerHTML;
        submitter.classList.add("is-submitting");
        submitter.setAttribute("aria-busy", "true");
        submitter.innerHTML = '<span class="app-skeleton" style="width:72px;height:12px;display:inline-block"></span>';
      }
    }, true);
  }

  function initInstantFeedback() {
    doc.addEventListener("click", function (event) {
      var action = event.target.closest("button, .btn, [role='button'], .quick-action-item, .app-bottom-nav__link");
      if (!action || action.disabled || action.getAttribute("aria-disabled") === "true") return;

      action.classList.add("is-pressed");
      win.setTimeout(function () {
        action.classList.remove("is-pressed");
      }, 180);
    }, true);
  }

  function collectCommandItems() {
    var items = [];
    doc.querySelectorAll("#mainNavbar a[href], .quick-action-item[href], .app-bottom-nav a[href]").forEach(function (link) {
      var text = link.textContent.replace(/\s+/g, " ").trim();
      var href = link.getAttribute("href");
      if (!text || !href || href === "#") return;
      if (items.some(function (item) { return item.href === href && item.text === text; })) return;
      items.push({ text: text, href: href });
    });
    return items.slice(0, 40);
  }

  function initCommandPalette() {
    var palette = doc.querySelector(".app-command-palette");
    if (!palette) return;

    var input = palette.querySelector(".app-command-palette__input");
    var list = palette.querySelector(".app-command-palette__list");
    var items = collectCommandItems();

    function render(query) {
      var normalized = (query || "").trim().toLowerCase();
      var filtered = items.filter(function (item) {
        return !normalized || item.text.toLowerCase().indexOf(normalized) !== -1;
      });

      list.innerHTML = "";
      if (!filtered.length) {
        var empty = doc.createElement("div");
        empty.className = "app-empty-state";
        empty.textContent = "نتیجه‌ای پیدا نشد.";
        list.appendChild(empty);
        return;
      }

      filtered.forEach(function (item) {
        var link = doc.createElement("a");
        var icon = doc.createElement("i");
        var label = doc.createElement("span");
        link.className = "app-command-palette__item";
        link.href = item.href;
        icon.className = "fas fa-location-arrow";
        icon.setAttribute("aria-hidden", "true");
        label.textContent = item.text;
        link.appendChild(icon);
        link.appendChild(label);
        list.appendChild(link);
      });
    }

    function openPalette() {
      items = collectCommandItems();
      render("");
      palette.classList.add("is-open");
      palette.setAttribute("aria-hidden", "false");
      win.setTimeout(function () {
        input.focus();
      }, 30);
    }

    function closePalette() {
      palette.classList.remove("is-open");
      palette.setAttribute("aria-hidden", "true");
      input.value = "";
    }

    doc.querySelectorAll("[data-command-palette-open]").forEach(function (button) {
      button.addEventListener("click", openPalette);
    });

    palette.addEventListener("click", function (event) {
      if (event.target === palette) closePalette();
    });

    input.addEventListener("input", function () {
      render(input.value);
    });

    doc.addEventListener("keydown", function (event) {
      var key = event.key.toLowerCase();
      if ((event.ctrlKey || event.metaKey) && key === "k") {
        event.preventDefault();
        openPalette();
      }
      if (event.key === "Escape" && palette.classList.contains("is-open")) {
        closePalette();
      }
    });
  }

  function initNetworkAwareness() {
    var banner = doc.querySelector(".app-network-banner");
    if (!banner) return;

    function sync() {
      doc.body.classList.toggle("is-offline", !navigator.onLine);
      if (!navigator.onLine) {
        banner.textContent = "اتصال اینترنت قطع است. تغییرات را بعد از اتصال دوباره بررسی کنید.";
      }
    }

    win.addEventListener("offline", function () {
      sync();
      showToast("اتصال اینترنت قطع شد.", "warning");
    });
    win.addEventListener("online", function () {
      sync();
      showToast("اتصال اینترنت برقرار شد.", "success");
    });
    sync();
  }

  function initDragScroll() {
    doc.querySelectorAll(".table-responsive, .responsive-table, .table-wrapper, .um-table-wrapper").forEach(function (scroller) {
      var isDown = false;
      var startX = 0;
      var scrollLeft = 0;

      scroller.addEventListener("pointerdown", function (event) {
        if (event.pointerType === "mouse" && event.button !== 0) return;


        // مشکل کلیک نشدن دکمه ها از اینجاست
        if (event.target.closest("button, a, input, select, textarea, label, .btn")) return;

        isDown = true;
        startX = event.clientX;
        scrollLeft = scroller.scrollLeft;
        scroller.setPointerCapture(event.pointerId);
      });

      scroller.addEventListener("pointermove", function (event) {
        if (!isDown) return;
        var delta = event.clientX - startX;
        scroller.scrollLeft = scrollLeft - delta;
      });

      ["pointerup", "pointercancel", "pointerleave"].forEach(function (name) {
        scroller.addEventListener(name, function () {
          isDown = false;
        });
      });
    });
  }

  function initActiveNavigation() {
    var current = win.location.pathname.replace(/\/+$/, "");
    doc.querySelectorAll(".app-bottom-nav__link[href]:not(.app-bottom-nav__brand)").forEach(function (link) {
      var href = new URL(link.getAttribute("href"), win.location.origin).pathname.replace(/\/+$/, "");
      link.classList.toggle("is-active", href === current);
    });
    doc.querySelectorAll(".app-mobile-menu__item[href]").forEach(function (link) {
      var href = new URL(link.getAttribute("href"), win.location.origin).pathname.replace(/\/+$/, "");
      link.classList.toggle("is-active", href === current);
    });
  }

  function initMobileMenuDrawer() {
    var drawer = doc.getElementById("mobileAppMenu");
    if (!drawer) return;

    var openButtons = doc.querySelectorAll("[data-mobile-menu-open]");
    var closeButtons = drawer.querySelectorAll("[data-mobile-menu-close]");
    var isOpen = false;
    var closeTimer = null;

    function setOpen(nextOpen) {
      if (isOpen === nextOpen) return;
      isOpen = nextOpen;

      if (closeTimer) {
        win.clearTimeout(closeTimer);
        closeTimer = null;
      }

      drawer.hidden = false;
      drawer.classList.toggle("is-open", nextOpen);
      drawer.setAttribute("aria-hidden", nextOpen ? "false" : "true");
      doc.body.classList.toggle("app-mobile-menu-open", nextOpen);

      openButtons.forEach(function (button) {
        button.setAttribute("aria-expanded", nextOpen ? "true" : "false");
        button.classList.toggle("is-active", nextOpen);
      });

      if (!nextOpen) {
        closeTimer = win.setTimeout(function () {
          drawer.hidden = true;
        }, 220);
      } else {
        drawer.hidden = false;
      }
    }

    function closeDrawer() {
      setOpen(false);
    }

    openButtons.forEach(function (button) {
      button.addEventListener("click", function () {
        setOpen(!isOpen);
      });
    });

    closeButtons.forEach(function (button) {
      button.addEventListener("click", closeDrawer);
    });

    drawer.addEventListener("click", function (event) {
      if (event.target === drawer || event.target.closest("[data-mobile-menu-close]")) {
        closeDrawer();
      }
    });

    drawer.addEventListener("click", function (event) {
      var link = event.target.closest(".app-mobile-menu__item[href], .tree-role-link[href]");
      if (link) {
        closeDrawer();
      }
    });

    doc.addEventListener("keydown", function (event) {
      if (event.key === "Escape" && isOpen) {
        closeDrawer();
      }
    });
  }

  function initProgressiveFilters() {
    doc.querySelectorAll(".filter-form, .um-filter-form").forEach(function (form) {
      var card = form.closest(".filter-card, .um-filter-card, .card");
      if (!card || card.dataset.progressiveReady) return;
      card.dataset.progressiveReady = "true";
      card.classList.add("app-progressive-filter");
    });
  }

  function getUsersPageKey(page) {
    var pageClass = Array.prototype.find.call(page.classList, function (className) {
      return className.indexOf("app-users-") === 0 && className !== "app-users-page";
    });
    return pageClass ? pageClass.replace("app-users-", "") : "general";
  }

  function initUsersJourney() {
    var page = doc.getElementById("content-limit");
    if (!page || !page.classList.contains("app-users-page")) return;

    var pageKey = getUsersPageKey(page);
    page.dataset.usersPage = pageKey;
    doc.body.dataset.usersPage = pageKey;

    var heading = page.querySelector("h1, h2, h3, .card-title");
    if (heading) {
      heading.classList.add("app-users-heading");
      page.setAttribute("aria-label", heading.textContent.trim());
    }

    page.querySelectorAll("form").forEach(function (form) {
      var controls = form.querySelectorAll("input:not([type='hidden']), select, textarea");
      if (controls.length >= 4) {
        form.classList.add("app-users-task-form");
      }

      var firstEmpty = Array.prototype.find.call(controls, function (control) {
        return !control.value && !control.disabled && !control.readOnly && control.type !== "file";
      });
      if (firstEmpty && !form.dataset.smartDefaultReady) {
        form.dataset.smartDefaultReady = "true";
        form.dataset.firstEmptyName = firstEmpty.name || firstEmpty.id || "";
      }

      form.querySelectorAll("[type='submit'], .btn-primary, .btn-success").forEach(function (button) {
        button.classList.add("app-primary-action");
      });
    });
  }

  function initUsersSearchAndFilters() {
    var page = doc.getElementById("content-limit");
    if (!page || !page.classList.contains("app-users-page")) return;

    page.querySelectorAll("form").forEach(function (form) {
      var searchControl = form.querySelector(
        'input[type="search"], input[name*="search" i], input[id*="search" i], select[name*="search" i], select[id*="search" i]'
      );
      if (searchControl) {
        form.classList.add("app-search-first");
        searchControl.closest(".form-group, .filter-group, .um-filter-group, .col, .col-12, div")?.classList.add("app-search-field");
      }
    });
  }

  function initUsersPersonalization() {
    var page = doc.getElementById("content-limit");
    if (!page || !page.classList.contains("app-users-page")) return;

    var pageKey = getUsersPageKey(page);
    try {
      var visits = JSON.parse(localStorage.getItem("app-users-visits") || "{}");
      visits[pageKey] = (visits[pageKey] || 0) + 1;
      localStorage.setItem("app-users-visits", JSON.stringify(visits));

      var favorite = Object.keys(visits).sort(function (a, b) {
        return visits[b] - visits[a];
      })[0];
      if (favorite) {
        doc.body.dataset.favoriteUsersPage = favorite;
      }
    } catch (error) {}
  }

  function initUsersOptimisticUi() {
    doc.addEventListener("submit", function (event) {
      var page = doc.getElementById("content-limit");
      if (!page || !page.classList.contains("app-users-page")) return;
      var form = event.target;
      if (!form.matches("form") || !form.checkValidity()) return;
      showToast("در حال ثبت تغییرات...", "info");
    }, true);
  }

  function initUsersRefactor() {
    initUsersJourney();
    initUsersSearchAndFilters();
    initUsersPersonalization();
    initUsersOptimisticUi();
  }

  ready(function () {
    initThemeMode();
    initTemplateRefactor();
    initUsersRefactor();
    initCardTables();
    observeTableChanges();
    initEmptyStates();
    initSmartValidation();
    initInstantFeedback();
    initCommandPalette();
    initNetworkAwareness();
    initDragScroll();
    initActiveNavigation();
    initMobileMenuDrawer();
    initProgressiveFilters();
  });
})();
