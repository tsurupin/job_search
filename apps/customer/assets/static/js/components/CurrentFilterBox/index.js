import React from 'react';
import PropTypes from 'prop-types';
import { CurrentFilterList, CurrentFilterItem } from 'components';
import { Wrapper, Icon } from './styles';
import GoSearch from 'react-icons/lib/go/search';

const propTypes = {
  items: PropTypes.arrayOf(PropTypes.shape).isRequired,
  handleReset: PropTypes.func.isRequired,
  handleResetTechKeyword: PropTypes.func.isRequired,
};

const CurrentFilterBox = ({ items, handleReset, handleResetTechKeyword }) => (
  <Wrapper>
    <Icon><GoSearch /></Icon>
    <CurrentFilterList
      items={items}
      handleReset={handleReset}
      handleResetTechKeyword={handleResetTechKeyword}
    />
  </Wrapper>
  );

CurrentFilterBox.propTypes = propTypes;
export default CurrentFilterBox;
