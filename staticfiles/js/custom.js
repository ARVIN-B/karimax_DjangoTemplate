// static/js/custom.js

$(document).ready(function() {
    // Loading spinner
    $(document).ajaxStart(function() {
        $('#loading').show();
    }).ajaxStop(function() {
        $('#loading').hide();
    });

    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        $('.alert').fadeOut('slow');
    }, 5000);

    // Confirm delete
    $('.btn-delete').click(function(e) {
        e.preventDefault();
        var url = $(this).attr('href');
        if (confirm('آیا از حذف این مورد مطمئن هستید؟')) {
            window.location.href = url;
        }
    });

    // Search with debounce
    let searchTimeout;
    $('#search-input').on('input', function() {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(function() {
            $('#search-form').submit();
        }, 300);
    });

    // Mobile menu toggle
    $('.navbar-toggler').click(function() {
        $('.mobile-menu').slideToggle(300);
    });

    // Smooth scrolling for anchor links
    $('a[href^="#"]').on('click', function(event) {
        var target = $(this.getAttribute('href'));
        if (target.length) {
            event.preventDefault();
            $('html, body').stop().animate({
                scrollTop: target.offset().top - 70
            }, 500);
        }
    });

    // Form validation enhancement
    $('form').on('submit', function(e) {
        var $form = $(this);
        $form.find('input, select, textarea').removeClass('is-invalid is-valid');

        // Basic client-side validation
        var isValid = true;
        $form.find('input[required], select[required]').each(function() {
            if (!$(this).val()) {
                $(this).addClass('is-invalid');
                isValid = false;
            } else {
                $(this).addClass('is-valid');
            }
        });

        if (!isValid) {
            e.preventDefault();
            showNotification('لطفاً تمام فیلدهای الزامی را پر کنید', 'warning');
        }
    });

    // National ID validation
    $('#id_national_id').on('input', function() {
        var val = $(this).val();
        if (val.length === 10 && /^\d{10}$/.test(val)) {
            $(this).removeClass('is-invalid').addClass('is-valid');
        } else if (val.length > 0) {
            $(this).removeClass('is-valid').addClass('is-invalid');
        } else {
            $(this).removeClass('is-invalid is-valid');
        }
    });

    // Phone number formatting
    $('#id_phone_number').on('input', function() {
        var val = $(this).val().replace(/\D/g, '');
        if (val.length > 11) val = val.substring(0, 11);
        $(this).val(val);
    });
});

// Notification function
function showNotification(message, type = 'info') {
    const alertHtml = `
        <div class="alert alert-${type} alert-dismissible fade show position-fixed"
             style="top: 20px; right: 20px; z-index: 9999; min-width: 300px;" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `;

    $('body').append(alertHtml);

    // Auto remove after 4 seconds
    setTimeout(() => {
        $('.alert').last().fadeOut(300, function() {
            $(this).remove();
        });
    }, 4000);
}

// Format Persian numbers
function toPersianNum(num) {
    const persianDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    return num.toString().replace(/\d/g, d => persianDigits[d]);
}

// Format date to Persian
function formatPersianDate(dateStr) {
    const date = new Date(dateStr);
    const persianDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    const day = toPersianNum(date.getDate().toString().padStart(2, '0'));
    const month = toPersianNum((date.getMonth() + 1).toString().padStart(2, '0'));
    const year = toPersianNum(date.getFullYear().toString());

    return `${day}/${month}/${year}`;
}

// Export table to CSV
function exportTableToCSV(filename) {
    const table = document.querySelector('table');
    if (!table) return;

    let csv = [];
    const rows = table.querySelectorAll('tr');

    for (let i = 0; i < rows.length; i++) {
        const row = [], cols = rows[i].querySelectorAll('td, th');

        for (let j = 0; j < cols.length; j++) {
            let colText = cols[j].innerText.replace(/"/g, '""');
            row.push('"' + colText + '"');
        }

        csv.push(row.join(','));
    }

    const csvFile = new Blob([csv.join('\n')], { type: 'text/csv' });
    const downloadLink = document.createElement('a');
    downloadLink.download = filename || 'data.csv';
    downloadLink.href = window.URL.createObjectURL(csvFile);
    downloadLink.style.display = 'none';
    document.body.appendChild(downloadLink);
    downloadLink.click();
    document.body.removeChild(downloadLink);
}
// اسکرول منوی نقش‌ها + قفل صفحه
$(document).on('show.bs.dropdown', '#userDropdown', function () {
    $('body').addClass('dropdown-open');
    // کمی تاخیر برای اعمال CSS
    setTimeout(() => {
        $('#userDropdown + .dropdown-menu').addClass('show');
    }, 10);
});

$(document).on('hide.bs.dropdown', '#userDropdown', function () {
    $('body').removeClass('dropdown-open');
});
