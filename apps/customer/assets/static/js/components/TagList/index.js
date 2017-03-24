import React from 'react';
import Wrapper from './Wrapper';
import Tag from './Tag';

const TagList = ({tags}) => {
  return(
    <Wrapper>
      {tags.map((tag, index) => {
        return <Tag key={index}>{tag}</Tag>
      })}
    </Wrapper>
  )

}


export default TagList;