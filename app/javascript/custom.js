window.addEventListener("load", function () {
  const addItemAttributeButton = document.getElementById("add_item_attribute");
  const itemAttributesBlock = document.getElementById("item_attributes");

  function addNewItemAttribute(num) {
    let divItemAttribute = document.createElement("div");
    divItemAttribute.id = `item_attribute_${num}`;
    divItemAttribute.classList = "item_attribute mb-3 d-flex gap-3";

    let inputAttributeName = document.createElement("input");
    inputAttributeName.name = `item_attributes[${num}][name]`;
    inputAttributeName.type = "text";
    inputAttributeName.classList = "form-control";
    inputAttributeName.placeholder = "Item's attribute";

    let selectAttributeType = document.createElement("select");
    selectAttributeType.name = `item_attributes[${num}][type]`;
    selectAttributeType.classList = "form-control";
    selectAttributeType.innerHTML = "<option value='String'>String</option><option value='Integer'>Integer</option>";

    let buttonAttributeRemove = document.createElement("button");
    buttonAttributeRemove.type = "button";
    buttonAttributeRemove.onclick = function() { document.getElementById(`item_attribute_${num}`).remove(); };
    buttonAttributeRemove.classList = "remove_item_attribute btn btn-danger";
    buttonAttributeRemove.innerHTML = "<span class='d-inline-block' style='width: 10px'>-</span>";

    divItemAttribute.appendChild(inputAttributeName);
    divItemAttribute.appendChild(selectAttributeType);
    divItemAttribute.appendChild(buttonAttributeRemove);

    itemAttributesBlock.appendChild(divItemAttribute);
  }

  if (addItemAttributeButton !== null) {
    addItemAttributeButton.addEventListener("click", function(){
      let itemAttributes = document.getElementsByClassName("item_attribute");
      let num = 0;

      if (itemAttributes.length > 0) {
        num = parseInt(itemAttributes[itemAttributes.length - 1].id.split("_")[2]) + 1;
      }

      addNewItemAttribute(num);
    });
  }
});
