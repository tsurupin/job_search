import React, { PropTypes } from 'react';
import { CurrentFilterList, CurrentFilterItem } from 'components';
import Wrapper from './Wrapper';
import Icon from './Icon';
import GoSearch from 'react-icons/lib/go/search';

const propTypes = {
  items: PropTypes.arrayOf(PropTypes.shape.isRequired).isRequired,
  handleReset: PropTypes.func.isRequired,
  handleResetTechKeyword: PropTypes.func.isRequired
};

const CurrentFilterBox = ({items, handleReset, handleResetTechKeyword}) => {
  return(
    <Wrapper>
      <Icon><GoSearch /></Icon>
      <CurrentFilterList
        items={items}
        handleReset={handleReset}
        handleResetTechKeyword={handleResetTechKeyword}
      />
    </Wrapper>
  )
}

CurrentFilterBox.propTypes = propTypes;
export default CurrentFilterBox;
