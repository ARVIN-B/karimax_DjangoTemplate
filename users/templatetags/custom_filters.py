from django import template
register = template.Library()

@register.filter
def get_dict_item(d, key):
    return d.get(key)