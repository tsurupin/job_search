import React, { PropTypes } from 'react';
import { CurrentFilterItem } from 'components';
import Wrapper from './styles';

const propTypes = {
  items: PropTypes.arrayOf(PropTypes.shape).isRequired,
  handleReset: PropTypes.func.isRequired,
  handleResetTechKeyword: PropTypes.func.isRequired
};

const CurrentFilterList= ({items, handleReset, handleResetTechKeyword}) => {
  return (
    <Wrapper>
      {items.map((item, index) => {
        let name = Object.keys(item)[0];
        let value = item[name];
        return (
          <CurrentFilterItem
            key={index}
            name={name}
            value={value}
            handleReset={handleReset}
            handleResetTechKeyword={handleResetTechKeyword}
          />
        );
      })}
    </Wrapper>
  )
};

CurrentFilterList.propTypes = propTypes;
export default CurrentFilterList;