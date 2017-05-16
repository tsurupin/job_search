import React from 'react';
import { Wrapper, Item } from './styles';

const SuggestedItemList = ({ name, suggestedItems, handleSelect }) => (
  <Wrapper>
    {suggestedItems.map(suggestedItem => (
      <Item key={suggestedItem} >
        <div onMouseDown={() => {
          handleSelect(name, suggestedItem);
        }}
        >
          {suggestedItem}
        </div>
      </Item>
        ))
      }
  </Wrapper>
  );

export default SuggestedItemList;
