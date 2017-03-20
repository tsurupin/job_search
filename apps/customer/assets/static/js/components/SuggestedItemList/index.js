import React from 'react';
import Wrapper from './Wrapper';
import Item from './Item';

const SuggestedItemList = ({name, suggestedItems, handleSelect}) => {
  return (
    <Wrapper>
      {suggestedItems.map((suggestedItem) => {
        return(
          <Item key={suggestedItem} >
            <div onClick={() => handleSelect(name, suggestedItem)}>
              {suggestedItem}
            </div>
          </Item>
        )
      })
      }
    </Wrapper>
  )
}

export default SuggestedItemList;